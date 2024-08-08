//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 8/7/24.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormmater.locale = Locale(identifier: "em_US_POSIX")
        dateFormmater.timeZone = .current
        return dateFormmater.date(from: self)
    }
    
    func convertToDisplayFormate () -> String {
        guard let date = self.convertToDate() else {
            return "N/A"
        }
        
        return date.convertToMonthYearFormat()
    }
}
