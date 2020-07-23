//
//  PBConsultationManager.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 6/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import Foundation

typealias ConsultationCompletionHandler = (_ success:Bool, _ message:String?, _ resultData:String?) -> Void

class PBConsultationManager {
    
    func postConsultation(id:Int, appointmentStatusID:Int, remarks:String,  prescription:String, completionHandler:@escaping ConsultationCompletionHandler) {
         guard let url = getConsultationURL() else {
             completionHandler(false, "invalid URL", nil)
             return
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
         let jsonBody:[String : Any] = ["Id" : id, "Appointment_Status_Id": appointmentStatusID, "Remarks": remarks, "Prescription": prescription]
         let jsonData = try! JSONSerialization.data(withJSONObject: jsonBody, options: [])
         guard let jsonStr = String(data: jsonData, encoding: .utf8) else {
             completionHandler(false, "invalid json body", nil)
             return
         }
         request.httpBody = jsonStr.data(using:.utf8)
         
         let session = URLSession.shared
         let task = session.dataTask(with: request) { (data, response, error) in
             guard let data = data, error == nil else {
                 completionHandler(false, "response error", nil)
                 return
             }
             
             let jsonDataStr = String(data: data, encoding: .utf8)
             print(jsonDataStr ?? "")
             
             do {
                 let resultData = try JSONDecoder().decode(ConsultationData.self, from: data)
                 completionHandler(resultData.isSuccess, resultData.message, resultData.data)
             }
             catch {
                 print(error)
                 completionHandler(false, error.localizedDescription, nil)
             }
         }
         
         task.resume()
     }
     
     private func getConsultationURL() -> URL? {
         let url = PBConstants.urlPrefix + "/api/Consultation/ConsultationUpdate"
         return URL(string: url)
     }
}
