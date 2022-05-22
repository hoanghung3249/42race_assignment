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
    
    func setupCategories(with data: BusinessModel) {
        businessNameLabel.text = "Categories"
        guard let categories = data.categories, !categories.isEmpty else { return }
        var categoriesDetail = ""
        for category in categories {
            if !category.title.isEmpty {
                if categoriesDetail.isEmpty {
                    categoriesDetail.append(category.title)
                } else {
                    categoriesDetail.append(" - \(category.title)")
                }
            }
        }
        
        businessLocationLabel.text = categoriesDetail
    }
    
    func setupContactInfo(with data: BusinessModel) {
        businessNameLabel.text = "Contact"
        guard let displayPhone = data.displayPhone else { return }
        businessLocationLabel.text = displayPhone
    }
    
    func setupRatingInfo(with data: BusinessModel) {
        guard let rating = data.rating else {
            businessNameLabel.text = "Rating: 0.0"
            return
        }
        businessNameLabel.text = "Rating: \(rating)"
        if let message = data.messaging?.useCaseText {
            businessLocationLabel.text = message
        } else {
            businessLocationLabel.text = ""
        }
    }
    
    func setupForWorkingHour(with data: BusinessModel) {
        guard let hours = data.hours,
                !hours.isEmpty,
                let hour = hours.first else { return }
        
        businessNameLabel.text = hour.isOpenNow ?? false ? "OPEN NOW" : "CLOSED"
        
        let currentDay = Date().dayNumberOfWeek()
        if let openHour = hour.open?.first(where: { $0.day == currentDay }), let start = openHour.start, let end = openHour.end {
            let index = start.index(start.startIndex, offsetBy: 2)
            var startHour = start
            var endHour = end
            startHour.insert(":", at: index)
            endHour.insert(":", at: index)
            
            businessLocationLabel.text = "\(startHour) - \(endHour)"
        }
    }
}
