//
//  BaseViewController.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 22/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
        setupErrorBinding()
    }
    
    func setupTableView() {
    }
    
    func setupBinding() {
    }
    
    func setupErrorBinding() {
        
    }

}
