//
//  Test2AlertView.swift
//  MCBaseAlertView
//
//  Created by zc_mc on 2021/9/15.
//

import UIKit

class Test2AlertView: MCBaseAlertView {

    override func setupSubviews() {
        super.setupSubviews()
        self.isGesture = true
        
        self.maskTapAction = {
            print("=====")
        }
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        self.dismiss(animation: .bottom)
    }

}
