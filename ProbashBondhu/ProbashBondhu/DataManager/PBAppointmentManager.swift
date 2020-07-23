//
//  PBAppointmentManager.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 5/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import Foundation

typealias AppointmentTypeCompletionHandler = (_ success:Bool, _ message:String?, _ appointmentTypes:[AppointmentType]) -> Void

typealias AppointmentCountCompletionHandler = (_ success:Bool, _ message:String?, _ appointmentCounts:[AppointmentCount]) -> Void

typealias AppointmentListCompletionHandler = (_ success:Bool, _ message:String?, _ appointmentPatients:[AppointmentData]) -> Void

class PBAppointmentManager
{
    func getAppointmentType(completionHandler:@escaping AppointmentTypeCompletionHandler) {
        guard let url = getAppointmentDataURL() else {
            completionHandler(false, "invalid URL", [])
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(false, "response error", [])
                return
            }
            
            let jsonDataStr = String(data: data, encoding: .utf8)
            print(jsonDataStr ?? "")
            
            do {
                let appointmentData = try JSONDecoder().decode(AppointmentDataModel.self, from: data)
                completionHandler(appointmentData.isSuccess, appointmentData.message, appointmentData.appointmentTypes)
            }
            catch {
                print(error)
                completionHandler(false, error.localizedDescription, [])
            }
        }
        
        task.resume()
    }
    
    func getAppointmentCount(doctorID:Int, completionHandler:@escaping AppointmentCountCompletionHandler) {
        guard let url = getAppointmentCountURL(doctorID) else {
            completionHandler(false, "invalid URL", [])
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(false, "response error", [])
                return
            }
            
            let jsonDataStr = String(data: data, encoding: .utf8)
            print(jsonDataStr ?? "")
            
            do {
                let appointmentData = try JSONDecoder().decode(AppointmentCountDataModel.self, from: data)
                completionHandler(appointmentData.isSuccess, appointmentData.message, appointmentData.appointmentCounts)
            }
            catch {
                print(error)
                completionHandler(false, error.localizedDescription, [])
            }
        }
        
        task.resume()
    }
    
    func getAppointmentPatientList(doctorID:Int, appointmentType:Int, completionHandler:@escaping AppointmentListCompletionHandler) {
        guard let url = getAppointmentPatientListURL(doctorID, appointmentType) else {
            completionHandler(false, "invalid URL", [])
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(false, "response error", [])
                return
            }
            
            let jsonDataStr = String(data: data, encoding: .utf8)
            print(jsonDataStr ?? "")
            
            do {
                let appointmentData = try JSONDecoder().decode(AppointmentPatientListModel.self, from: data)
                completionHandler(appointmentData.isSuccess, appointmentData.message, appointmentData.appointments ?? [])
            }
            catch {
                print(error)
                completionHandler(false, error.localizedDescription, [])
            }
        }
        
        task.resume()
    }
    
    private func getAppointmentCountURL(_ doctorID:Int) -> URL? {
        
        let url = PBConstants.urlPrefix + "/api/Appointment/GetAppointmentStatusCounts/\(doctorID)"
        
        return URL(string: url)
    }
    
    private func getAppointmentPatientListURL(_ doctorID:Int, _ appointmentType:Int) -> URL? {
        
        let url = PBConstants.urlPrefix + "/api/Consultation/AppointmentPatientList"
        
        var urlComponents = URLComponents(string: url)
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "doctorId", value: "\(doctorID)"))
        queryItems.append(URLQueryItem(name: "appointmentStatusId", value: "\(appointmentType)"))
        urlComponents?.queryItems = queryItems

        return urlComponents?.url
    }
    
    private func getAppointmentDataURL() -> URL? {
        let url = PBConstants.urlPrefix + "/api/Appointment/GetAppointmentStatus"
           
        return URL(string: url)
    }
}
