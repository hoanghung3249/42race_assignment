//
//  HomeViewModel.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    
    private var bag = DisposeBag()
    private var latitude: Double?
    private var longitude: Double?
    private(set) var businesses = BehaviorRelay<[BusinessModel]>(value: [])
    private(set) var errorRelay = PublishRelay<String>()
    var finishedGetLocation = BehaviorRelay<Void>(value: ())
    
    init() {
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
                APIProvider.shared.request(.searchWithLocation(latitude: self?.latitude ?? 0.0, longitude: self?.longitude ?? 0.0), mapObject: BusinessesResponseModel.self)
            })
            .map({ $0.businesses.sorted { b1, b2 in
                b1.distance ?? 0.0 < b2.distance ?? 0.0 && b1.rating ?? 0.0 > b2.rating ?? 0.0
            } })
            .asDriver { [weak self] error in
                self?.errorRelay.accept((error as? APIError)?.description ?? "")
                return Driver.just([])
            }
            .drive(businesses)
            .disposed(by: bag)
    }
    
}
