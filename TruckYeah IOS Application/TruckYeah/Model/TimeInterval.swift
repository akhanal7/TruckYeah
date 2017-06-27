//
//  TimeInterval.swift
//  TruckYeah
//
//  Created by Nicholas Teissler on 3/28/17.
//  Copyright © 2017 ChooChoo Computing. All rights reserved.
//

import Foundation

struct TimeRange {
    // Int must be beteen 0 and 23 and 0 and 59
    let timeStart: Time
    let timeEnd: Time
    
    func contains(_ time: Time) -> Bool {
        let startHour = (timeStart.hours == time.hours && timeStart.minutes < time.minutes) || time.hours > timeStart.hours
        let endHour = (timeEnd.hours == time.hours && timeEnd.minutes > time.minutes) || time.hours < timeEnd.hours
        return startHour && endHour
    }
    
    init(timeStart: Time, timeEnd: Time) {
        
        if timeEnd.hours < 9 { // we assume it's PM
            self.timeEnd = Time(hours: timeEnd.hours + 12, minutes: timeEnd.minutes)            // convert to military time
        } else {
            self.timeEnd = timeEnd
        }
        if timeStart.hours < 9 { // assume PM
            self.timeStart = Time(hours: timeStart.hours + 12, minutes: timeStart.minutes)            // convert to military time
        } else {
            self.timeStart = timeStart
        }
    }
    
    struct Time {
        let hours: Int
        let minutes: Int
        
        init(militaryTime: String) {
            // parse something like 12:30, 13:30, 1:05 into the right time
            let colonRange = militaryTime.range(of: ":")
            
            let startIndex = militaryTime.startIndex
            let colonIndex = militaryTime.index(startIndex, offsetBy:militaryTime.distance(from: startIndex, to: (colonRange?.lowerBound)!))
            let afterColonIndex = militaryTime.index(startIndex, offsetBy: militaryTime.distance(from: startIndex, to: (colonRange?.upperBound)!))
            //let endIndex = militaryTime.endIndex
            
            let hours = Int(militaryTime.substring(to: colonIndex))!
            let minutes = Int(militaryTime.substring(from: afterColonIndex))!
            self.init(hours: hours, minutes: minutes)
        }
        
        init(hours: Int, minutes: Int) {
            self.hours = hours
            self.minutes = minutes
        }
        
    }
}


