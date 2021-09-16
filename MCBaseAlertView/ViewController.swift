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

    @IBAction func alertViewClicked(_ sender: Any) {
        
        let alert = Test2AlertView()
        alert.show(animation: .bottom)
        
    }
    
    @IBAction func alertControllerClicked(_ sender: Any) {
        
        let alertC = TestViewController()
        present(alertC, animated: true, completion: nil)
    }
    
    @IBAction func sheetControllerClicked(_ sender: Any) {
        
        let sheet = MCSheetController()
        sheet.isGesture = true
        sheet.addAction(MCSheetAction(name: "哈哈哈", action: {

        }))
        sheet.addAction(MCSheetAction(name: "嘿嘿", action: {

        }))

        self.present(sheet, animated: true, completion: nil)
    }
    
    
}

