//
//  PBConsultationViewController.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 6/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import UIKit

protocol ConsultationStatusDelegate: class {
    func onConsultCancel()
    func onConsultSubmit()
}


class PBConsultationViewController: UIViewController {
    
    @IBOutlet weak var mScrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var ageTextView: UITextView!
    @IBOutlet weak var genderTextView: UITextView!
    @IBOutlet weak var mobileTextView: UITextView!
    @IBOutlet weak var problemsTextView: UITextView!
    @IBOutlet weak var appointmentStatusTextView: UITextView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var prescriptionTextView: UITextView!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var spinnerViewBg: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var contentOffsetY:CGFloat = 0.0
    var contentHeight:CGFloat = 0.0
    
    var appointmentID = 0
    var appointmentTypes = [AppointmentType]()
    var selectedAppointmentIndex = 0
    
    var appointmentData:AppointmentData!
    
    let consultationManager = PBConsultationManager()
    
    weak var delegate:ConsultationStatusDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mScrollView.contentSize = CGSize(width: mScrollView.contentSize.width, height: contentHeight)
        contentOffsetY = mScrollView.contentOffset.y
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupUI() {
        submitBtn.layer.cornerRadius = 2
        submitBtn.layer.borderWidth = 1
        submitBtn.layer.borderColor = UIColor.black.cgColor
        
        closeBtn.layer.cornerRadius = 2
        closeBtn.layer.borderWidth = 1
        closeBtn.layer.borderColor = UIColor.black.cgColor
         
        nameTextView.layer.borderWidth = 1
        nameTextView.layer.borderColor = UIColor.black.cgColor
        
        ageTextView.layer.borderWidth = 1
        ageTextView.layer.borderColor = UIColor.black.cgColor
        
        genderTextView.layer.borderWidth = 1
        genderTextView.layer.borderColor = UIColor.black.cgColor
        
        mobileTextView.layer.borderWidth = 1
        mobileTextView.layer.borderColor = UIColor.black.cgColor
        
        problemsTextView.layer.borderWidth = 1
        problemsTextView.layer.borderColor = UIColor.black.cgColor
        
        appointmentStatusTextView.layer.borderWidth = 1
        appointmentStatusTextView.layer.borderColor = UIColor.black.cgColor
        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.black.cgColor
        
        prescriptionTextView.layer.borderWidth = 1
        prescriptionTextView.layer.borderColor = UIColor.black.cgColor
        
        appointmentStatusTextView.text = appointmentTypes[selectedAppointmentIndex].name
        pickerView.selectRow(selectedAppointmentIndex, inComponent: 0, animated: false)
        pickerView.isHidden = true
        
        contentHeight = 30.0 * 6
        contentHeight += 60.0
        contentHeight += 200.0
        contentHeight += 15.0 * 9
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneKeyboard))]
        toolbar.sizeToFit()
        commentTextView.inputAccessoryView = toolbar
        prescriptionTextView.inputAccessoryView = toolbar
        
        setupData()

    }

    func setupData() {
        appointmentID = appointmentData.id
        
        nameTextView.text = appointmentData.patient?.name ?? ""
        ageTextView.text = "\(appointmentData.patient?.age ?? 0)"
        genderTextView.text = appointmentData.patient?.genderList.name ?? ""
        mobileTextView.text = appointmentData.patient?.mobile ?? ""
        problemsTextView.text = appointmentData.problems
        commentTextView.text = appointmentData.remarks
        prescriptionTextView.text = appointmentData.prescription
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        delegate?.onConsultCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    func showSpinner() {
        DispatchQueue.main.async {
            self.spinnerViewBg.isUserInteractionEnabled = true
            self.spinner.startAnimating()
        }
    }
    func hideSpinner() {
        DispatchQueue.main.async {
            self.spinnerViewBg.isUserInteractionEnabled = false
            self.spinner.stopAnimating()
        }
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        showSpinner()
        
        selectedAppointmentIndex = pickerView.selectedRow(inComponent: 0)
        let appointmentStatus = appointmentTypes[selectedAppointmentIndex].id
        
        let remarks = commentTextView.text ?? ""
        let prescription = prescriptionTextView.text ?? ""
        consultationManager.postConsultation(id: appointmentID, appointmentStatusID: appointmentStatus, remarks: remarks, prescription: prescription) { (isSuccess, message, data) in
            print(message)
            DispatchQueue.main.async {
                self.hideSpinner()
                if isSuccess {
                    self.delegate?.onConsultSubmit()
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    let errorMsg = message ?? ""
                    self.showToast(message: "Error Occurred :\(errorMsg)", font: UIFont.systemFont(ofSize: 12))
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let extraHeight = keyboardSize.height/2
            mScrollView.contentSize = CGSize(width: mScrollView.contentSize.width, height: contentHeight + extraHeight)
            mScrollView.contentOffset.y = contentOffsetY + extraHeight
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        mScrollView.contentSize = CGSize(width: mScrollView.contentSize.width, height: contentHeight)
        mScrollView.contentOffset.y = contentOffsetY
    }
    
    @objc func doneKeyboard() {
        commentTextView.resignFirstResponder()
        prescriptionTextView.resignFirstResponder()
    }
}


extension PBConsultationViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

        return appointmentTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        view.endEditing(true)
        return appointmentTypes[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.appointmentStatusTextView.text = appointmentTypes[row].name
        pickerView.isHidden = true
    }
}

extension PBConsultationViewController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView == appointmentStatusTextView {
            pickerView.isHidden = false
            textView.endEditing(true)
        }
    }
}
