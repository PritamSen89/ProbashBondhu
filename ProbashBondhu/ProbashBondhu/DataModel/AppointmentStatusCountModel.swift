//
//  AppointmentStatusCountModel.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 4/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import Foundation

struct AppointmentCount:Codable  {
    var key:Int
    var value:Int
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case value = "Value"
    }
}

struct AppointmentCountDataModel:Codable  {
    var appointmentCounts:[AppointmentCount]
    var isSuccess:Bool
    var message:String
    
    enum CodingKeys: String, CodingKey {
        case appointmentCounts = "Data"
        case isSuccess = "IsSuccess"
        case message = "Message"
    }
}
