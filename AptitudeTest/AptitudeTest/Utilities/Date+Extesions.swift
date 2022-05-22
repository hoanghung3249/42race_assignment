//
//  Date+Extesions.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 22/05/2022.
//

import Foundation

extension Date {
    
    func dayNumberOfWeek() -> Int? {
        let weekDay = Calendar.current.dateComponents([.weekday], from: self).weekday
        guard let weekDay = weekDay else {
            return nil
        }

        // Convert to match yelp API
        switch weekDay {
            // Sunday
        case 1: return 6
            // Monday
        case 2: return 0
            // Tuesday
        case 3: return 1
            // Wednesday
        case 4: return 2
            // Thursday
        case 5: return 3
            // Friday
        case 6: return 4
            // Saturday
        case 7: return 5
        default: return nil
        }
        
    }
    
}
