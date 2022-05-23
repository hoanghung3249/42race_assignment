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

enum BusinessDetailType {
    case address, categories, contact, rating, hours
    
    var numberOfRow: Int {
        switch self {
        case .address: return 1
        case .categories: return 1
        case .contact: return 1
        case .rating: return 1
        case .hours: return 1
        }
    }
}

final class BusinessDetailViewModel: BaseViewModel {
    
    private var businessId: String?
    private(set) var businessModel = BehaviorRelay<BusinessModel?>(value: nil)
    private(set) var businessImage = BehaviorRelay<UIImage?>(value: nil)
    private(set) var businessDetailType: [BusinessDetailType] = [.address, .categories, .contact, .rating, .hours]
    
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
