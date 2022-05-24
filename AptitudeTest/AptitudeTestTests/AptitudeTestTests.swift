//
//  AptitudeTestTests.swift
//  AptitudeTestTests
//
//  Created by Hung Nguyen on 21/05/2022.
//

import XCTest
import RxTest
import RxBlocking
import RxSwift
import CoreLocation
@testable import AptitudeTest

class AptitudeTestTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var serviceAPI: ServiceAPI!
    var viewModel: HomeViewModel!
    var testScheduler: TestScheduler!
    var scheduler: ConcurrentDispatchQueueScheduler!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        serviceAPI = .searchWithLocation(latitude: 37.785834, longitude: -122.406417)
        testScheduler = TestScheduler(initialClock: 0)
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        viewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        disposeBag = nil
        serviceAPI = nil
        testScheduler = nil
        scheduler = nil
        viewModel = nil
    }

    func testFirstLoadData() {
        let sortType = testScheduler.createObserver(BusinessSortType.self)
        let searchType = testScheduler.createObserver(BusinessSearchType.self)
        let searchText = testScheduler.createObserver(String.self)
        
        viewModel.businessSortType
            .bind(to: sortType)
            .disposed(by: disposeBag)
        
        viewModel.businessSearchType
            .bind(to: searchType)
            .disposed(by: disposeBag)
        
        viewModel.searchText
            .bind(to: searchText)
            .disposed(by: disposeBag)
        
        XCTAssertRecordedElements(sortType.events, [.distance])
        XCTAssertRecordedElements(searchType.events, [.term])
        XCTAssertRecordedElements(searchText.events, [])
    }
    
    func testGetAPIResponse() {
        let expactation = XCTestExpectation(description: "Response successfully")
        
        APIProvider.shared.request(serviceAPI, offSet: "0", mapObject: BusinessesResponseModel.self)
            .subscribe(onNext: { model in
                XCTAssertNotNil(model)
                
                expactation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expactation], timeout: 3)
    }
    
    func testGetLocalBusinesses() {
        let expactation = XCTestExpectation(description: "Businesses list not empty")
        
        APIProvider.shared.request(serviceAPI, offSet: "0", mapObject: BusinessesResponseModel.self)
            .subscribe(onNext: { model in
                XCTAssertEqual(model.businesses.count, 40)
                XCTAssertNotEqual(model.total, 0)
                expactation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expactation], timeout: 3)
    }
    
    func testSortBySelected() {
        let sortType = testScheduler.createObserver(BusinessSortType.self)
        
        viewModel.businessSortType
            .bind(to: sortType)
            .disposed(by: disposeBag)
        
        testScheduler
            .createColdObservable([
                .next(30, BusinessSortType.distance),
                .next(40, BusinessSortType.rating)
            ])
            .bind(to: viewModel.businessSortType)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        XCTAssertEqual(sortType.events, [
            .next(0, .distance),
            .next(30, .distance),
            .next(40, .rating)
        ])
    }
    
    func testSearchBySelected() {
        let searchType = testScheduler.createObserver(BusinessSearchType.self)
        
        viewModel.businessSearchType
            .bind(to: searchType)
            .disposed(by: disposeBag)
        
        testScheduler
            .createColdObservable([
                .next(30, BusinessSearchType.address),
                .next(35, BusinessSearchType.address),
                .next(40, BusinessSearchType.cuisine)
            ])
            .bind(to: viewModel.businessSearchType)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        XCTAssertEqual(searchType.events, [
            .next(0, .term),
            .next(30, .address),
            .next(35, .address),
            .next(40, .cuisine)
        ])
    }
    
    func testSearchText() {
        let searchText = testScheduler.createObserver(String.self)
        
        viewModel.searchText
            .bind(to: searchText)
            .disposed(by: disposeBag)
        
        testScheduler
            .createColdObservable([
                .next(30, "hot"),
                .next(35, "dog")
            ])
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        
        XCTAssertEqual(searchText.events, [
            .next(30, "hot"),
            .next(35, "dog")
        ])
    }
    
    func testCombineQueries() {
        let sortType = testScheduler.createObserver(BusinessSortType.self)
        let searchType = testScheduler.createObserver(BusinessSearchType.self)
        let searchText = testScheduler.createObserver(String.self)
        
        viewModel.businessSortType
            .bind(to: sortType)
            .disposed(by: disposeBag)
        
        viewModel.businessSearchType
            .bind(to: searchType)
            .disposed(by: disposeBag)
        
        viewModel.searchText
            .bind(to: searchText)
            .disposed(by: disposeBag)
        
        testScheduler
            .createColdObservable([
                .next(10, BusinessSortType.rating),
                .next(25, BusinessSortType.distance)
            ])
            .bind(to: viewModel.businessSortType)
            .disposed(by: disposeBag)
        
        testScheduler
            .createColdObservable([
                .next(10, BusinessSearchType.address),
                .next(40, .cuisine)
            ])
            .bind(to: viewModel.businessSearchType)
            .disposed(by: disposeBag)
        
        testScheduler
            .createColdObservable([
                .next(10, "hot"),
                .next(35, "dog")
            ])
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        XCTAssertEqual(searchText.events, [
            .next(10, "hot"),
            .next(35, "dog")
        ])
        
        XCTAssertEqual(sortType.events, [
            .next(0, .distance),
            .next(10, .rating),
            .next(25, .distance)
        ])
        
        XCTAssertEqual(searchType.events, [
            .next(0, .term),
            .next(10, .address),
            .next(40, .cuisine)
        ])
    }
    
    func testGetBusinessDetail() {
        let expactation = XCTestExpectation(description: "Businesses list not empty")
        
        var businessId: String?
        
        APIProvider.shared.request(serviceAPI, offSet: "0", mapObject: BusinessesResponseModel.self)
            .flatMapLatest({ model -> Observable<BusinessModel> in
                businessId = model.businesses.randomElement()?.id
                XCTAssertNotNil(businessId, "BusinessId shot not be nil")
                expactation.fulfill()
                return APIProvider.shared.request(.businessDetail(id: businessId!), mapObject: BusinessModel.self)
            })
            .subscribe(onNext: { model in
                XCTAssertNotNil(model.name, "Business should not be nil")
                expactation.fulfill()
            }).disposed(by: disposeBag)
         
        
        wait(for: [expactation], timeout: 3)
    }

}
