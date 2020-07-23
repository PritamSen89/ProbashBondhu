//
//  DrawerView.swift
//  slideOutTest
//
//  Created by PRI on 3/26/19.
//  Copyright © 2019 PRI. All rights reserved.
//

import UIKit

protocol DrawerControllerDelegate: class {
    func pushTo(viewController : UIViewController)
}

struct CellData {
    var title:String
    var imageName:String
    var count:Int
}

class DrawerView: UIView, drawerProtocol, UITableViewDelegate, UITableViewDataSource {
    
    public let screenSize = UIScreen.main.bounds
    var bgView = UIView()
    var drawerView = UIView()
    
    var tblVw = UITableView()
    
    weak var delegate:DrawerControllerDelegate?
    var currentViewController = UIViewController()
    
    var vwForHeader = UIView()
    var navigationHeight:CGFloat = 64.0
    
    fileprivate var gradientLayer: CAGradientLayer!
    
    
    var items = [CellData]()

    convenience init(aryControllers: [CellData], controller:UIViewController, navigationHeight:CGFloat) {
        self.init(frame: UIScreen.main.bounds)
        self.tblVw.register(UINib.init(nibName: "DrawerCell", bundle: nil), forCellReuseIdentifier: "DrawerCell")
        self.initialize(controllers: aryControllers, controller:controller, navigationHeight: navigationHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // To change the background color of background view
    func changeGradientColor(colorTop:UIColor, colorBottom:UIColor) {
        let holderColor = UIColor(displayP3Red: 34.0/255.0, green: 39.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        gradientLayer.colors = [holderColor.cgColor, colorBottom.cgColor]
        self.drawerView.layer.insertSublayer(gradientLayer, at: 0)
    }

    func initialize(controllers:[CellData], controller:UIViewController, navigationHeight:CGFloat) {
        self.navigationHeight = navigationHeight
        currentViewController = controller
        currentViewController.tabBarController?.tabBar.isHidden = true
        
        bgView.frame = frame
        drawerView.backgroundColor = UIColor.clear
        bgView.backgroundColor = UIColor.white
        bgView.alpha = 0.6

        // Initialize the tap gesture to hide the drawer.
        let tap = UITapGestureRecognizer(target: self, action: #selector(DrawerView.dismissDrawerView))
        bgView.addGestureRecognizer(tap)
        addSubview(bgView)
        
        drawerView.frame = CGRect(x:0, y:0, width:screenSize.width/2+75, height:screenSize.height)
        drawerView.clipsToBounds = true

        // Initialize the gradient color for background view
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = drawerView.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.darkGray.cgColor]

        self.allocateLayout(controllers:controllers)
    }
    
    func allocateLayout(controllers:[CellData]) {
        vwForHeader.backgroundColor =  UIColor(displayP3Red: 34.0/255.0, green: 39.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        
        vwForHeader = UIView(frame:CGRect(x:0, y:0, width:drawerView.frame.size.width, height:navigationHeight))
        tblVw.frame = CGRect(x:0, y:vwForHeader.frame.origin.y+vwForHeader.frame.size.height, width:screenSize.width/2+75, height:screenSize.height-64)
        
        tblVw.separatorStyle = UITableViewCell.SeparatorStyle.none
        items = controllers
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.backgroundColor = UIColor(displayP3Red: 42.0/255.0, green: 49.0/255.0, blue: 53.0/255.0, alpha: 0.8)
        drawerView.addSubview(tblVw)
        tblVw.reloadData()

        
        let lblNav = UILabel(frame:CGRect(x:15, y:0, width:vwForHeader.frame.size.width, height:vwForHeader.frame.size.height))
        lblNav.text = "MAIN NAVIGATION"
        lblNav.textAlignment = .left
        lblNav.textColor = UIColor(displayP3Red: 95.0/255.0, green: 99.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        vwForHeader.addSubview(lblNav)

        drawerView.addSubview(vwForHeader)
        addSubview(drawerView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell") as! DrawerCell
        cell.backgroundColor = UIColor.clear
        cell.lblController?.text = items[indexPath.row].title
        cell.imgController?.image = UIImage(named:items[indexPath.row].imageName)
        if items[indexPath.row].count > 0 {
            cell.countLabel.isHidden = false
            cell.countLabel.text = "\(items[indexPath.row].count)"
        }
        else {
            cell.countLabel.isHidden = true
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissDrawerView()
    }

    @objc func dismissDrawerView() {
        self.dissmissDrawer()
    }
}
