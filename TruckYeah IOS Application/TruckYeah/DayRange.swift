//
//  DateRange.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 3/16/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import Foundation

struct DayRange {
    enum Day: String {
        case Mon
        case Tue
        case Wed
        case Thu
        case Fri
        case Sat
        case Sun
    }
    
    let timeRange: TimeRange
    let day: Day
    
}

extension DayRange {
    init(timePoint: TimeRange.Time, day: Day) {
        self.timeRange = TimeRange(timeStart: timePoint, timeEnd: timePoint)
        self.day = day
        
    }
}
