//
//  Utility.swift
//  Time Attendance System
//
//  Created by Omeir Ahmed on 24/10/2020.
//  Copyright © 2020 Omeir Ahmed. All rights reserved.
//

import Foundation

class Utility {
    static func getDateFormatCurrentTimeZone(by date:Date, format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}
