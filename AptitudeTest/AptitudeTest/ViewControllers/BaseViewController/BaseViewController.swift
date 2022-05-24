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
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
        setupErrorBinding()
    }
    
    // Need to override this method if using tableview
    func setupTableView() {
    }
    
    // Need to override this method for binding value
    func setupBinding() {
    }
    
    // Need to override this method for binding error
    func setupErrorBinding() {
        
    }

}

extension BaseViewController {
    
    func showAlert(title: String? = "ERROR", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
}
