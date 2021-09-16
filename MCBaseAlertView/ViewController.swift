//
//  ViewController.swift
//  MCBaseAlertView
//
//  Created by zc_mc on 2021/9/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showClicked(_ sender: Any) {
        
        let alert = Test2AlertView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        alert.show(animation: .bottom)
        
    }
    
}

