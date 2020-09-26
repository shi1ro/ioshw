//
//  ViewController.swift
//  hw1
//
//  Created by apple on 2020/9/23.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var showView: UIView!
    @IBOutlet weak var switchButton: UIButton!
    var switchstate = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonFunc(){
        if(switchstate == 0){
            switchstate = 1
            switchButton.setTitle("OFF", for:UIControl.State.normal)
            showView.backgroundColor = UIColor.white
        }
        else if(switchstate == 1){
            switchstate = 0;
            switchButton.setTitle("ON", for:UIControl.State.normal)
            showView.backgroundColor = UIColor.black
        }
    }

}

