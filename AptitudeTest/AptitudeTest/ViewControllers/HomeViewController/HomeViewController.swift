//
//  HomeViewController.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.didUpdateLocation = { (location) in
            guard let location = location else { return }
            print(location)
            APIProvider.shared.request(.searchWithLocation(latitude: location.latitude, longitude: location.longitude), mapObject: BusinessesResponseModel.self) { result in
                switch result {
                case .success(let model):
                    print(model.businesses.first)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

// MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hello"
        return cell
    }
    
}

// MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate {
    
}
