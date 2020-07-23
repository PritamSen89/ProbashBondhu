//
//  PBLoginViewController.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 6/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import UIKit

class PBLoginViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var wrongInfoLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var spinnerBgView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var contentOffsetY:CGFloat = 0.0
    var contentHeight:CGFloat = 0.0
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentOffsetY = scrollView.contentOffset.y
        contentHeight = scrollView.contentSize.height
    }
    
    func setupUI() {
        cardView.layer.cornerRadius = 5.0
        loginBtn.layer.cornerRadius = 2.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneKeyboard))]
        toolbar.sizeToFit()
        userIDTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        guard let userID = userIDTextField.text, let password = passwordTextField.text, !userID.isEmpty, !password.isEmpty else {
            wrongInfoLabel.isHidden = false
            return
        }
        showSpinner()
        
        PBLoginDataManager.shared.requestLogin(userName: userID, userPswd: password) { (isSuccess, Message, userData) in
            if isSuccess && (userData != nil && userData?.isAdmin == false && userData?.isAgent == false && userData?.id != nil) {
                self.onLoginSuccess(userData?.id ?? -1)
            }
            else {
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.wrongInfoLabel.isHidden = false
                }
            }
        }
        
    }
    
    func onLoginSuccess(_ doctorID:Int) {
        PBLoginDataManager.shared.saveDoctorID(doctorID)
        DispatchQueue.main.async {
            self.hideSpinner()
            if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showHomeScreen()
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let extraHeight = keyboardSize.height/2
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: contentHeight + extraHeight)
            scrollView.contentOffset.y = contentOffsetY + extraHeight
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: contentHeight)
        scrollView.contentOffset.y = contentOffsetY
    }
    
    @objc func doneKeyboard() {
        userIDTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func showSpinner() {
        DispatchQueue.main.async {
            self.spinnerBgView.isUserInteractionEnabled = true
            self.spinner.startAnimating()
        }
    }

    func hideSpinner() {
        DispatchQueue.main.async {
            self.spinnerBgView.isUserInteractionEnabled = false
            self.spinner.stopAnimating()
        }
    }

}
