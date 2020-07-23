//
//  UserDataModel.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 4/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import Foundation

struct Country:Codable
{
    var id:Int //Id
    var name:String // Name
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}

struct UserData:Codable  {
    var isAdmin:Bool //Is_Admin
    var isAgent:Bool //Is_Agent
    var id:Int //Id
    var name:String // Name
    var mobile:String // Mobile
    var userName:String // Username
    var primarySpecializationName:String? // Primary_Specialization_Name
    var secondarySpecializationName:String? // Secondary_Specialization_Name
    var otherSpecialization:String? // Other_Specialization
    var livingCity:String? //Living_City
    var affiliatedHospital:String? //Affiliated_Hospital
    var countryID:Int? // Country_Id
    var country:Country? //Country
    
    enum CodingKeys: String, CodingKey {
        case isAdmin = "Is_Admin"
        case isAgent = "Is_Agent"
        case id = "Id"
        case name = "Name"
        case mobile = "Mobile"
        case userName = "Username"
        case primarySpecializationName = "Primary_Specialization_Name"
        case secondarySpecializationName = "Secondary_Specialization_Name"
        case otherSpecialization = "Other_Specialization"
        case livingCity = "Living_City"
        case affiliatedHospital = "Affiliated_Hospital"
        case countryID = "Country_Id"
        case country = "Country"
    }
}

struct LoginUserData:Codable  {
    var userData:UserData // UserData
    var newAppointments:Int // NewAppointments
    
    enum CodingKeys: String, CodingKey {
        case userData = "UserData"
        case newAppointments = "NewAppointments"
    }
}

struct LoginData:Codable  {
    var data:LoginUserData?
    var isSuccess:Bool
    var message:String
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case isSuccess = "IsSuccess"
        case message = "Message"
    }
}



