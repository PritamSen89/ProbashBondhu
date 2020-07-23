//
//  AppointmentTypesTableViewCell.swift
//  ProbashBondhuDemo
//
//  Created by Pritam on 5/7/20.
//  Copyright © 2020 Pritam. All rights reserved.
//

import UIKit

protocol AppointmentTypeCellDelegate: class {
    func onSelect(_ type:Int)
}

class AppointmentTypesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countLabelView: UIView!
    
    let imageChecked = UIImage(named: "radio_checked_icon")
    let imageUnchecked = UIImage(named: "radio_unchecked_icon")
    
    var apponintmentType:Int = 0
    weak var delegate:AppointmentTypeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        countLabelView.layer.cornerRadius = 2.0
    }
    
    func setRadioButtonStatus(_ isSelected:Bool) {
        if isSelected {
            radioBtn.setImage(imageChecked, for: .normal)
        }
        else {
            radioBtn.setImage(imageUnchecked, for: .normal)
        }
    }
    
    func setData(_ type:Int, _ name:String, _ count:Int) {
        apponintmentType = type
        typeLabel.text = name
        countLabel.text = "\(count)"
    }
    
    @IBAction func onRadioBtnPressed(_ sender: Any) {
        delegate?.onSelect(apponintmentType)
    }
}
