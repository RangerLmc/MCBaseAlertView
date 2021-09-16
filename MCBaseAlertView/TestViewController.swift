//
//  TestViewController.swift
//  MCBaseAlertView
//
//  Created by zc_mc on 2021/9/16.
//

import UIKit

class TestViewController: BaseAlertController {

    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showView(aniView: contentView, isGesture: true)
    }

    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismissView(aniView: contentView)
        
    }
    
}
