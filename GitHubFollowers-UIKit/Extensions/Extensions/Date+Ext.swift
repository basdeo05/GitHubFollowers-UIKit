//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 8/7/24.
//

import Foundation

extension Date {
    func convertToMonthYearFormat () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    

}
