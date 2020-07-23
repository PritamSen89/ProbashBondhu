//
//  HomeViewController.swift
//  slideOutTest
//
//  Created by PRI on 3/26/19.
//  Copyright © 2019 PRI. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, DrawerControllerDelegate, AppointmentTypeCellDelegate, PatientCellDelegate, ConsultationStatusDelegate {


    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var patientTableView: UITableView!
    
    @IBOutlet weak var mTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mPatientTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var spinnerBgView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var drawerVw = DrawerView()
    let APPOINTMENT_CELL_ID = "appointment_type_cell_id"
    let PATIENT_CELL_ID = "patient_cell_id"
    let PATIENT_HEADER_ID = "patient_header_id"

    var doctorID:Int = 0
    let pbManager = PBAppointmentManager()

    @IBOutlet weak var searchCountLabel: UILabel!
    var appointmentList = [AppointmentData]()
    var searchedAppointmentList = [AppointmentData]()
    var appointmentTypes = [AppointmentType]()
    var appointmentCount = [Int:Int]()
    var selectedTypeIndex = 0
    var searchText = ""
    var contentOffsetY:CGFloat = 0.0
    var contentHeight:CGFloat = 0.0
    
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBGViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let moreIcon = UIImage(named: "burger_menu_icon")
        let tintedMoreImage = moreIcon?.withRenderingMode(.alwaysTemplate)
        
        let color = UIColor.white
        
        let revealButtonItem = UIBarButtonItem(image: tintedMoreImage, style: .plain, target: self, action: #selector(actShowMenu))
        revealButtonItem.tintColor = color
        self.navigationItem.leftBarButtonItem  = revealButtonItem
        
        let logoutButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(onLogoutBtnPressed))
        logoutButtonItem.tintColor = color
        self.navigationItem.rightBarButtonItem  = logoutButtonItem
        
        setupUI()
        setupTableView()
        loadData()
        
        //test()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentOffsetY = scrollView.contentOffset.y
        contentHeight = scrollView.contentSize.height
    }
    
    func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneKeyboard))]
        toolbar.sizeToFit()
        searchBar.inputAccessoryView = toolbar
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
        searchBar.resignFirstResponder()
    }
    
    
    func test() {
        if let path = Bundle.main.path(forResource: "AppointmentPatientListDemoData", ofType: "json")
        {
            do {
             let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let appointmentData = try JSONDecoder().decode(AppointmentPatientListModel.self, from: data)
                print(appointmentData.appointments?.count)
            } catch {
                print(error)
            }
        
        }
    }

    func pushTo(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func actShowMenu() {
        let consultationCount = PBLoginDataManager.shared.getNewAppointmentCount()
        let cellData = [CellData(title: "Consultation", imageName: "consult", count: consultationCount)]
        let navHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 64.0)
        drawerVw = DrawerView(aryControllers:cellData, controller:self, navigationHeight: navHeight)
        drawerVw.delegate = self
        
        drawerVw.changeGradientColor(colorTop: UIColor.groupTableViewBackground, colorBottom: UIColor.white)
        drawerVw.showDrawer()
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadData() {
        getAppointmentTypes()
    }
    
    func getAppointmentTypes() {
        showSpinner()
        pbManager.getAppointmentType { (isSuccess, message, types) in
            print(message)
            if isSuccess {
                self.appointmentTypes = types
                self.appointmentTypes.sort(by: {$0.priority < $1.priority})
                self.getAppointmentCount(self.doctorID)
            }
            else {
                self.hideSpinner()
                let errorMsg = message ?? ""
                self.showToast(message: errorMsg, font: UIFont.systemFont(ofSize: 12.0))
            }
        }
    }
    
    func getAppointmentCount(_ doctorID:Int) {
        showSpinner()
        pbManager.getAppointmentCount(doctorID: doctorID) { (isSuccess, message, appointmentCounts) in
            print(message)
            if isSuccess {
                self.appointmentCount.removeAll()
                for appointment in appointmentCounts {
                    self.appointmentCount[appointment.key] = appointment.value
                }
                
                DispatchQueue.main.async {
                    self.reloadAppointmentTableView()
                }
            }
            else {
                self.hideSpinner()
                let errorMsg = message ?? ""
                self.showToast(message: errorMsg, font: UIFont.systemFont(ofSize: 12.0))
            }
        }
    }
    
    func reloadAppointmentTableView() {
        mTableViewHeightConstraint.constant = CGFloat(appointmentTypes.count * 35)
        mTableView.reloadData()
        
        refreshAppointmentListView()
    }
    
    func refreshAppointmentListView() {
        if appointmentTypes.count > selectedTypeIndex {
            let selectedAppointmentType = appointmentTypes[selectedTypeIndex]
            getPatientList(doctorID, selectedAppointmentType.id)
        }
    }
    
    func reloadPatientTableView() {
        searchedAppointmentList = searchText.count == 0 ? appointmentList : appointmentList.filter({
            ($0.patient?.name.localizedCaseInsensitiveContains(searchText) ?? false)
        })
    
        let firstCount = searchedAppointmentList.count > 0 ? 1 : 0
        let lastCount = searchedAppointmentList.count
        let searchedCount =  searchedAppointmentList.count
        let actualCount = appointmentList.count
        searchCountLabel.text = "Showing \(firstCount) to \(lastCount) of \(searchedCount) entries"
        if searchedCount < actualCount {
            searchCountLabel.text = (searchCountLabel.text ?? "") + " (filtered from \(actualCount) total entries)"
        }
        mPatientTableViewHeightConstraint.constant = CGFloat(searchedAppointmentList.count * 50 + 50)
        patientTableView.reloadData()
        calculateScrollViewHeight()
        hideSpinner()
    }
    
    func getPatientList(_ doctorID:Int, _ type:Int) {
        pbManager.getAppointmentPatientList(doctorID: doctorID, appointmentType: type) { (isSuccess, message, appointmentList) in
            print(message)
            if isSuccess {
                self.appointmentList = appointmentList
                DispatchQueue.main.async {
                    self.reloadPatientTableView()
                }
            }
            else {
                self.hideSpinner()
                let errorMsg = message ?? ""
                self.showToast(message: errorMsg, font: UIFont.systemFont(ofSize: 12.0))
            }
        }
    }
    
    func setupTableView()
    {
        let appointmentTypeCellNib = UINib(nibName: "AppointmentTypesTableViewCell", bundle:nil)
        mTableView.register(appointmentTypeCellNib, forCellReuseIdentifier: APPOINTMENT_CELL_ID)
        

        let patientHeaderNib = UINib(nibName: "PatientListHeaderView", bundle: nil)
        patientTableView.register(patientHeaderNib, forHeaderFooterViewReuseIdentifier: PATIENT_HEADER_ID)

        let patientCellNib = UINib(nibName: "PatientListTableViewCell", bundle:nil)
        patientTableView.register(patientCellNib, forCellReuseIdentifier: PATIENT_CELL_ID)
    }
    
    func calculateScrollViewHeight() {
        contentHeight = mTableViewHeightConstraint.constant
        contentHeight += mPatientTableViewHeightConstraint.constant
        contentHeight += 5 + 50 + 20 + 21
        contentHeight += 20 + 16 + 10
        contentHeight += 40 + 10
        contentHeight += 5
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: contentHeight)
        
        containerViewHeightConstraint.constant = contentHeight > UIScreen.main.bounds.size.height ? contentHeight : UIScreen.main.bounds.size.height
        
        containerBGViewHeightConstraint.constant = containerViewHeightConstraint.constant
    }
    
    func onSelect(_ type: Int) {
        let currentIndex = getIndex(type)
        if selectedTypeIndex != currentIndex {
            selectedTypeIndex = currentIndex
            reloadAppointmentTableView()
        }
    }
    
    func getIndex(_ type:Int) -> Int {
        return appointmentTypes.firstIndex(where: { $0.id == type }) ?? 0
    }
    
    @objc func onLogoutBtnPressed() {
        PBLoginDataManager.shared.saveDoctorID(nil)
        DispatchQueue.main.async {
            if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showLoginScreen()
            }
        }
    }
    
    func onConsultBtnPressed(_ appointmentIndex: Int) {
        let vc = PBConsultationViewController(nibName: "PBConsultationViewController", bundle: nil)
        vc.appointmentTypes = appointmentTypes
        vc.selectedAppointmentIndex = selectedTypeIndex
        vc.appointmentData = searchedAppointmentList[appointmentIndex]
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)

    }
    
    func onConsultCancel() {
        //DO nothing
    }
    
    func onConsultSubmit() {
        self.showToast(message: "Submitted successfully.", font: UIFont.systemFont(ofSize: 12))
        self.getAppointmentCount(self.doctorID)
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

extension HomeViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mTableView {
            return appointmentTypes.count
        }
        else {
            return searchedAppointmentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell()
        if tableView == mTableView {
            let appointmentType = appointmentTypes[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: APPOINTMENT_CELL_ID, for:indexPath)
            (cell as! AppointmentTypesTableViewCell).setData(appointmentType.id, appointmentType.name, appointmentCount[appointmentType.id] ?? 0)
            (cell as! AppointmentTypesTableViewCell).setRadioButtonStatus(selectedTypeIndex == indexPath.row)
            (cell as! AppointmentTypesTableViewCell).delegate = self
            
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: PATIENT_CELL_ID, for:indexPath)
            let patientInfo = searchedAppointmentList[indexPath.row].patient
            (cell as! PatientListTableViewCell).delegate = self
            (cell as! PatientListTableViewCell).appointmentIndex = indexPath.row
            (cell as! PatientListTableViewCell).setData(patientInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == mTableView {
            return 35
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == mTableView {
            return 0
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PATIENT_HEADER_ID) as! PatientListHeaderView
        return headerView
    }
}

extension HomeViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchBar.text ?? ""
        reloadPatientTableView()
    }
}
