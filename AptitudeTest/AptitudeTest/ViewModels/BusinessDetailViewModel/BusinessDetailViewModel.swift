//
//  BusinessDetailViewModel.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 22/05/2022.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Kingfisher
import UIKit

final class BusinessDetailViewModel {
    
    private var businessId: String?
    private var bag = DisposeBag()
    private(set) var businessModel = BehaviorRelay<BusinessModel?>(value: nil)
    private(set) var businessImage = BehaviorRelay<UIImage?>(value: nil)
    private(set) var errorRelay = PublishRelay<String>()
    
    init(businessId: String) {
        self.businessId = businessId
        
        print("Id: \(businessId)")
    }
    
    func getBusinessDetail() {
        guard let businessId = businessId else {
            return
        }

        APIProvider
            .shared
            .request(.businessDetail(id: businessId),
                     mapObject: BusinessModel.self)
            .asDriver { [weak self] error in
                self?.errorRelay.accept((error as? APIError)?.description ?? "")
                return Driver.empty()
            }
            .drive(onNext: { [weak self] model in
                self?.businessModel.accept(model)
            })
            .disposed(by: bag)

        
    }
    
}
