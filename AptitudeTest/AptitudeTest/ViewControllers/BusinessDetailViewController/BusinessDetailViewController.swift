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
    
    
    override func setupTableView() {
        tableView.register(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
    }
    
    override func setupBinding() {
        viewModel?.getBusinessDetail()
        viewModel?.businessModel
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
//                self.showAlert(alertMessage: error.description)
                print(error)
            }
            .disposed(by: bag)
    }

}

extension BusinessDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?.businessModel.value else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell else { return UITableViewCell() }
            
            cell.setup(with: model)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell else { return UITableViewCell() }
            
            cell.setupCategories(with: model)
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell else { return UITableViewCell() }
            
            cell.setupContactInfo(with: model)
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell else { return UITableViewCell() }
            cell.setupRatingInfo(with: model)
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell else { return UITableViewCell() }
            cell.setupForWorkingHour(with: model)
            return cell
        default: return UITableViewCell()
        }
    }
}
