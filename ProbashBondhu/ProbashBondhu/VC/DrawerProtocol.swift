//
//  drawerProtocol.swift
//  slideOutTest
//
//  Created by PRI on 3/26/19.
//  Copyright © 2019 PRI. All rights reserved.
//

import UIKit
import Foundation


protocol drawerProtocol{
    func showDrawer()
    func dissmissDrawer()

    var bgView : UIView{set get}
    var drawerView : UIView{set get}
}

extension drawerProtocol where Self:UIView{
    
    func showDrawer()
    {
        self.drawerView.frame.origin = CGPoint(x:-self.frame.size.width, y:0)
        bgView.alpha = 0.0

        UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0.6
            self.drawerView.frame.origin = CGPoint(x:0, y:0)
        }
    }
    
    func dissmissDrawer()
    {
       UIView.animate(withDuration: 0.2, animations: {
        self.drawerView.frame.origin = CGPoint(x:-self.frame.size.width, y:0)
        self.bgView.alpha = 0.0
        
       }) { (completion) in
            self.removeFromSuperview()
        }
    }
    
}
