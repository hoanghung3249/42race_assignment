//
//  BusinessCell.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessLocationLabel: UILabel!
    
    private var businessModel: BusinessModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with data: BusinessModel) {
        businessNameLabel.text = data.name
        guard let location = data.location else { return }
        businessLocationLabel.text = "\(location.address1 ?? "") - \(location.city ?? "")"
    }
    
}
