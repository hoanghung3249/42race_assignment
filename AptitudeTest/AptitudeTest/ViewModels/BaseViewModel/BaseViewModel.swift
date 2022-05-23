//
//  BaseViewModel.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 23/05/2022.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    var bag = DisposeBag()
    var errorRelay = PublishRelay<String>()
    
    var total = 0
    var offSet = 0
    
}
