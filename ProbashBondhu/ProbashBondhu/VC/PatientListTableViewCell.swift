//
//  PatientListTableViewCell.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 5/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import UIKit

protocol PatientCellDelegate: class {
    func onConsultBtnPressed(_ appointmentIndex:Int)
}

class PatientListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var consultBtn: UIButton!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var appointmentIndex = 0
    weak var delegate:PatientCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        consultBtn.layer.cornerRadius = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ patientInfo:Patient?) {
        nameLabel.text = patientInfo?.name ?? ""
        ageLabel.text = "\(patientInfo?.age ?? 0)"
        genderLabel.text = patientInfo?.genderList.name ?? ""
    }
    
    @IBAction func onConsultBtnPressed(_ sender: Any) {
        delegate?.onConsultBtnPressed(appointmentIndex)
    }
}
