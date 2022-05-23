//
//  HomeViewModel.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import Foundation
import RxSwift
import RxCocoa

enum BusinessSeachType {
    case term
}

final class HomeViewModel: BaseViewModel {
    
    private var latitude: Double?
    private var longitude: Double?
    private var isPaginationOn = false
    private var isFirstLoad = true
    private(set) var businesses = BehaviorRelay<[BusinessModel]>(value: [])
    var finishedGetLocation = BehaviorRelay<Void>(value: ())
    
    override init() {
        super.init()
        LocationManager.shared.didUpdateLocation = { [weak self] (location) in
            guard let self = self, let location = location else { return }
            print(location)
            self.latitude = location.latitude
            self.longitude = location.longitude
            self.finishedGetLocation.accept(())
        }
        
        binding()
    }
    
    private func binding() {
        
        finishedGetLocation
            .asObservable()
            .flatMapLatest({ [weak self] _ in
                APIProvider.shared.request(.searchWithLocation(latitude: self?.latitude ?? 0.0, longitude: self?.longitude ?? 0.0, offSet: "0"), mapObject: BusinessesResponseModel.self)
            })
            .asDriver { [weak self] error in
                self?.errorRelay.accept((error as? APIError)?.description ?? "")
                return Driver.empty()
            }
            .drive(onNext: { [weak self] businessResponseModel in
                guard let self = self else { return }
                self.total = businessResponseModel.total
                self.isFirstLoad = false
                var value = self.businesses.value
                value.append(contentsOf: businessResponseModel.businesses)
                self.businesses.accept(value)
            })
            .disposed(by: bag)
    }
    
    func fetchMoreBusiness(isPagination: Bool) {
        guard !isFirstLoad else { return }
        if isPagination {
            isPaginationOn = true
        }
        if offSet + 40 <= total {
            offSet += 40
        } else {
            let newOffset = total - offSet
            offSet += newOffset
        }
        print("----Offset: \(offSet)")
        APIProvider.shared.request(.searchWithLocation(latitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0, offSet: "\(offSet)"), mapObject: BusinessesResponseModel.self)
            .asDriver { [weak self] error in
                    self?.errorRelay.accept((error as? APIError)?.description ?? "")
                    return Driver.empty()
            }
            .drive(onNext: { [weak self] businessResponseModel in
                guard let self = self else { return }
                if isPagination {
                    self.isPaginationOn = false
                }
                self.total = businessResponseModel.total
                var value = self.businesses.value
                value.append(contentsOf: businessResponseModel.businesses)
                self.businesses.accept(value)
            })
            .disposed(by: bag)
    }
    
}
