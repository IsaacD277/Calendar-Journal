//
//  Day.swift
//  Calendar Journal
//
//  Created by Isaac D2 on 6/3/24.
//

import SwiftUI
import Foundation

struct Day: Identifiable, Hashable {
    var id: UUID = .init()
    var shortSymbol: String
    var date: Date
    
    var weekDayName: String
    /// Previous/Next Month Excess Dates
    var ignored: Bool
    
    init(shortSymbol: String, date: Date, ignored: Bool = false) {
        self.id = UUID()
        self.shortSymbol = shortSymbol
        self.date = date
        
        switch Calendar.current.component(.weekday, from: date) {
        case 1:
            self.weekDayName = "Sunday"
        case 2:
            self.weekDayName = "Monday"
        case 3:
            self.weekDayName = "Tuesday"
        case 4:
            self.weekDayName = "Wednesday"
        case 5:
            self.weekDayName = "Thursday"
        case 6:
            self.weekDayName = "Friday"
        case 7:
            self.weekDayName = "Saturday"
        default:
            self.weekDayName = "Day not found"
        }
        
        self.ignored = ignored
        // print(Calendar.current.component(.weekday, from: date))
    }
}

extension Day {
    static var dummy: Day {
        .init(shortSymbol: "05", date: Date.now)
    }
}
