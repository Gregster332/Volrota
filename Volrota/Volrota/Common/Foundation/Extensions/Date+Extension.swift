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
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: self)
    }
    
    func isDateExpiredSoon() -> Bool {
        let calendar = Calendar.current
        let from = calendar.startOfDay(for: Date())
        let to = calendar.startOfDay(for: self)
        let numberOfDays = calendar.dateComponents([.day], from: from, to: to).day ?? 0
        return numberOfDays <= 10
    }
}
