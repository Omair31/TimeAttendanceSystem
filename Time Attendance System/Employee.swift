//
//  Employee.swift
//  Time Attendance System
//
//  Created by Omeir Ahmed on 24/10/2020.
//  Copyright © 2020 Omeir Ahmed. All rights reserved.
//

import Foundation

struct Employee {
    
    var name:String
    var email:String
    var phoneNumber:String
    var department:String
    
    static var currentEmployee:Employee?
}
