//
//  HomeViewModel.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import Foundation
import RxSwift
import RxCocoa

enum BusinessSearchType: Int {
    case term = 0
    case address
    case cuisine
}

enum BusinessSortType: Int {
    case distance = 0
    case rating
    
    var stringValue: String {
        switch self {
        case .distance: return "distance"
        case .rating: return "rating"
        }
    }
}

final class HomeViewModel: BaseViewModel {
    
    private var latitude: Double?
    private var longitude: Double?
    var isPaginationOn = false
    private var isFirstLoad = true
    private var serviceAPI: ServiceAPI?
    private(set) var businesses = BehaviorRelay<[BusinessModel]>(value: [])
    var businessSortType = BehaviorRelay<BusinessSortType>(value: .distance)
    var businessSearchType = BehaviorRelay<BusinessSearchType>(value: .term)
    var searchText = PublishRelay<String>()
    var reloadData = BehaviorRelay<Void>(value: ())
    
    override init() {
        super.init()
        LocationManager.shared.didUpdateLocation = { [weak self] (location) in
            guard let self = self, let location = location else { return }
            print(location)
            self.latitude = location.latitude
            self.longitude = location.longitude
            self.reloadData.accept(())
        }
        
        binding()
    }
    
    private func binding() {
        // Combine sort_by, search by and search text to fetch data
        Observable.combineLatest(reloadData, businessSortType, businessSearchType, searchText)
            .map({ [weak self] (_, sortType, searchType, text) in
                
                let service = ServiceAPI.searchBusiness(latitude: self?.latitude ?? 0.0, longitude: self?.longitude ?? 0.0, sortBy: sortType.stringValue, searchBy: searchType, searchText: text)
                self?.serviceAPI = service
                return service
            })
            .flatMapLatest({ [weak self] service in
                APIProvider
                    .shared
                    .request(service,
                            mapObject: BusinessesResponseModel.self)
                    .trackActivity(self?.loadingActivity ?? ActivityIndicator())
            })
            .asDriver { [weak self] error in
                self?.errorRelay.accept((error as? APIError)?.description ?? "")
                return Driver.empty()
            }
            .drive(onNext: { [weak self] businessResponseModel in
                guard let self = self else { return }
                self.setTotalResponse(businessResponseModel.total)
                self.resetOffSet()
                self.isFirstLoad = false
                self.businesses.accept(businessResponseModel.businesses)
            })
            .disposed(by: bag)
    }
    
    func fetchMoreBusiness(isPagination: Bool) {
        guard !isFirstLoad else { return }
        guard let serviceAPI = serviceAPI else {
            print("Cannot get the service API")
            return
        }

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
        
        APIProvider.shared.request(serviceAPI, offSet: "\(offSet)", mapObject: BusinessesResponseModel.self)
            .trackActivity(self.loadingActivity)
            .asDriver { [weak self] error in
                    self?.errorRelay.accept((error as? APIError)?.description ?? "")
                    return Driver.empty()
            }
            .drive(onNext: { [weak self] businessResponseModel in
                guard let self = self else { return }
                if isPagination {
                    self.isPaginationOn = false
                }
                self.setTotalResponse(businessResponseModel.total)
                // Appending data
                var value = self.businesses.value
                value.append(contentsOf: businessResponseModel.businesses)
                self.businesses.accept(value)
            })
            .disposed(by: bag)
    }
    
}
