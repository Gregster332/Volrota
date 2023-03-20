//
//  Date+Extension.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import Foundation

extension Date {
    
    static func datePeriod(from startDate: Date, endDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy HH:mm"
        formatter.calendar = Calendar.current
        formatter.locale = .autoupdatingCurrent
        
        return formatter.string(from: startDate) + " - " + formatter.string(from: endDate)
        
    }
}
