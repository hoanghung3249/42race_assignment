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

extension BaseViewController {
    
    func showAlert(title: String? = "ERROR", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
}
