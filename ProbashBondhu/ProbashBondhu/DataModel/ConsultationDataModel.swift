//
//  ConsultationDataModel.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 6/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import Foundation

struct ConsultationData:Codable  {
    var data:String?
    var isSuccess:Bool
    var message:String
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case isSuccess = "IsSuccess"
        case message = "Message"
    }
}
