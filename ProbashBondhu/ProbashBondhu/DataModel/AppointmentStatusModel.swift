//
//  AppointmentStatusModel.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 4/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import Foundation

struct AppointmentType:Codable  {
    var id:Int
    var name:String
    var priority:Int
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case priority = "Priority"
    }
}

struct AppointmentDataModel:Codable  {
    var appointmentTypes:[AppointmentType]
    var isSuccess:Bool
    var message:String
    
    enum CodingKeys: String, CodingKey {
        case appointmentTypes = "Data"
        case isSuccess = "IsSuccess"
        case message = "Message"
    }
}
