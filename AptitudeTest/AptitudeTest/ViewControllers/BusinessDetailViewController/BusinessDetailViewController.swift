//
//  BusinessDetailViewController.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 22/05/2022.
//

import UIKit
import RxSwift
import Kingfisher

class BusinessDetailViewController: BaseViewController {
    
    var viewModel: BusinessDetailViewModel?
    
    @IBOutlet weak var businessImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycles
    
    override func setupTableView() {
        tableView.register(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
    }
    
    override func setupBinding() {
        guard let viewModel = viewModel else {
            return
        }

        viewModel.getBusinessDetail()
        
        viewModel.loadingActivity
            .asDriver()
            .drive(indicatorView.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel.businessModel
            .subscribe(onNext: { [weak self] model in
                guard let self = self, let model = model else { return }
                self.title = model.name
                if let imageUrl = URL(string: model.imageUrl ?? "") {
                    self.businessImageView.kf.setImage(with: imageUrl)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }).disposed(by: bag)
    }
    
    override func setupErrorBinding() {
        viewModel?.errorRelay
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] error in
                guard let self = self else { return }
                self.showAlert(message: error)
            }
            .disposed(by: bag)
    }

}

// MARK: - TableView Datasource
extension BusinessDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.businessDetailType.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let businessType = viewModel?.businessDetailType[section] else { return 0 }
        return businessType.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?.businessModel.value, let businessType = viewModel?.businessDetailType else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell else { return UITableViewCell() }
        
        switch businessType[indexPath.section] {
        case .address:
            cell.setup(with: model)
        case .categories:
            cell.setupCategories(with: model)
        case .contact:
            cell.setupContactInfo(with: model)
        case .rating:
            cell.setupRatingInfo(with: model)
        case .hours:
            cell.setupForWorkingHour(with: model)
        }
        
        return cell
    }
}
