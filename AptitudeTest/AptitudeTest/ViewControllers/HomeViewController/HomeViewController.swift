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
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var sortBySegment: UISegmentedControl!
    
    @IBOutlet weak var searchBySegment: UISegmentedControl!
    
    private let refreshControl = UIRefreshControl()
    private var viewModel = HomeViewModel()
    
    // MARK: - Life Cycle
    
    override func setupTableView() {
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    override func setupBinding() {
        viewModel.loadingActivity
            .asDriver()
            .drive(indicatorView.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel.businesses
            .subscribe(onNext: { [weak self] models in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }).disposed(by: bag)
        
        sortBySegment.rx
            .value
            .map({ BusinessSortType(rawValue: $0) ?? .distance })
            .bind(to: viewModel.businessSortType)
            .disposed(by: bag)
        
        searchBySegment.rx
            .value
            .map({ BusinessSearchType(rawValue: $0) ?? .term })
            .bind(to: viewModel.businessSearchType)
            .disposed(by: bag)
        
        searchTextField.rx
            .text
            .orEmpty
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchText)
            .disposed(by: bag)
    }
    
    override func setupErrorBinding() {
        viewModel.errorRelay
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] error in
                guard let self = self else { return }
                self.showAlert(message: error)
            }
            .disposed(by: bag)
    }
    
    @objc private func refreshData(_ sender: Any) {
        viewModel.reloadData.accept(())
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
        if pos > tableView.contentSize.height - 50 - scrollView.frame.size.height {
            guard !viewModel.isPaginationOn else { return }
            
            viewModel.fetchMoreBusiness(isPagination: true)
        }
    }
}
