//
//  PBLoginDataManager.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 5/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import Foundation

typealias LoginCompletionHandler = (_ success:Bool, _ message:String?, _ userData:UserData?) -> Void

class PBLoginDataManager
{
    public static let shared = PBLoginDataManager()
    
    private var doctorID:Int?
    private var loginUserData:LoginUserData?
    
    func requestLogin(userName:String, userPswd:String, completionHandler:@escaping LoginCompletionHandler) {
        guard let url = getURL() else {
            completionHandler(false, "invalid URL", nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody = ["Username" : userName, "Password": userPswd]
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
                let userData = try JSONDecoder().decode(LoginData.self, from: data)
                self.loginUserData = userData.data
                completionHandler(userData.isSuccess, userData.message, userData.data?.userData)
            }
            catch {
                print(error)
                completionHandler(false, error.localizedDescription, nil)
            }
        }
        
        task.resume()
    }
    
    func getURL() -> URL? {
        let url = PBConstants.urlPrefix + "/api/Login/index"
        
        return URL(string: url)
    }
    
    func saveDoctorID(_ id:Int?) {
        doctorID = id
    }
    
    func getDoctorID() -> Int? {
        return doctorID
    }
    
    func getNewAppointmentCount() -> Int {
        loginUserData?.newAppointments ?? 0
    }
}
