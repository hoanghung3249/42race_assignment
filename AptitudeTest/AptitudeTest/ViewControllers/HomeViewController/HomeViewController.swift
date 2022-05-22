//
//  HomeViewController.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import UIKit
import RxSwift

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel = HomeViewModel()
    
    // MARK: - Life Cycle
    
    override func setupTableView() {
        tableView.register(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
    }
    
    override func setupBinding() {
        viewModel.businesses
            .subscribe(onNext: { [weak self] models in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }).disposed(by: bag)
    }
    
    override func setupErrorBinding() {
        viewModel.errorRelay
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] error in
                guard let self = self else { return }
//                self.showAlert(alertMessage: error.description)
                print(error)
            }
            .disposed(by: bag)
    }
}

// MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.businesses.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell else { return UITableViewCell() }
        let model = viewModel.businesses.value[indexPath.row]
        
        cell.setup(with: model)
        return cell
    }
    
}

// MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.businesses.value[indexPath.row]
        guard let businessId = model.id else {
            return
        }
        let businessDetailViewModel = BusinessDetailViewModel(businessId: businessId)
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BusinessDetailViewController") as? BusinessDetailViewController else { return }
        vc.viewModel = businessDetailViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
