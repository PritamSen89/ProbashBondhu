//
//  AppointmentPatientList.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 4/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import Foundation

struct AppointmentStatus:Codable  {
    var id:Int
    var name:String
    var Priority:Int
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case Priority = "Priority"
    }
}

struct User:Codable  {
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


struct GenderList:Codable {
    var id:Int
    var name:String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}

struct Patient:Codable {
    var id:Int
    var name:String
    var age:Int
    var gender:Int
    var location:String?
    var mobile:String
    var countryId:Int?
    var remarks:String?
    var flag:Bool?
    var genderList:GenderList
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case age = "Age"
        case gender = "Gender"
        case location = "Location"
        case mobile = "Mobile"
        case countryId = "Country_Id"
        case remarks = "Remarks"
        case flag = "Flag"
        case genderList = "Gender_List"
    }
}

struct AppointmentData:Codable {
    var id:Int
    var patientId:Int
    var doctorId:Int
    var appointmentTime:String?
    var appointmentStatusId:Int
    var prescription:String?
    var remarks:String?
    var problems:String?
    var patient:Patient?
    var appointmentStatus:AppointmentStatus?
    var user:User
    var createdOn:String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case patientId = "Patient_Id"
        case doctorId = "Doctor_Id"
        case appointmentTime = "Appointment_Time"
        case appointmentStatusId = "Appointment_Status_Id"
        case prescription = "Prescription"
        case remarks = "Remarks"
        case problems = "Problems"
        case patient = "Patient"
        case appointmentStatus = "Appointment_Status"
        case user = "User"
        case createdOn = "Created_On"
    }
}


struct AppointmentPatientListModel:Codable {
    var appointments:[AppointmentData]?
    var isSuccess:Bool
    var message:String
    
    enum CodingKeys: String, CodingKey {
        case appointments = "Data"
        case isSuccess = "IsSuccess"
        case message = "Message"
    }
}
