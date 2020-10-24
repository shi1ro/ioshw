//
//  ViewController.swift
//  171830568calculator
//
//  Created by apple on 2020/10/22.
//  Copyright © 2020 shi1ro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cal = CalculModel()
    var butcolor = UIColor()
    var radmode = false
    var secmode = false
    @IBOutlet weak var anslabel: UILabel!
    @IBOutlet weak var radbut: UIButton!
    @IBOutlet weak var secbut: UIButton!
    @IBOutlet weak var specexpbut: UIButton!
    @IBOutlet weak var speclogbut: UIButton!
    @IBOutlet weak var sinbut: UIButton!
    @IBOutlet weak var cosbut: UIButton!
    @IBOutlet weak var tanbut: UIButton!
    @IBOutlet weak var sinhbut: UIButton!
    @IBOutlet weak var coshbut: UIButton!
    @IBOutlet weak var tanhbut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        butcolor = radbut.backgroundColor!
  /*      var mylist:[Int] = [1,2,3,4]
        print(mylist[mylist.endIndex - 1])
        mylist.remove(at: mylist.endIndex - 1)
        print(mylist)*/
    }
    func radModeChange(but : UIButton){
        if(!radmode){
            but.backgroundColor = UIColor.gray
        }
        else{
            but.backgroundColor = butcolor
        }
        radmode = !radmode
    }
    func secModeChange(but : UIButton){
        if(!secmode){
           but.backgroundColor = UIColor.gray
            sinbut.setTitle("sin-1", for: UIControl.State.normal)
            cosbut.setTitle("cos-1", for: UIControl.State.normal)
            tanbut.setTitle("tan-1", for: UIControl.State.normal)
            sinhbut.setTitle("sinh-1", for: UIControl.State.normal)
            coshbut.setTitle("cosh-1", for: UIControl.State.normal)
            tanhbut.setTitle("tanh-1", for: UIControl.State.normal)
            specexpbut.setTitle("2^x", for: UIControl.State.normal)
            speclogbut.setTitle("log2", for: UIControl.State.normal)
        }
        else{
            but.backgroundColor = butcolor
            sinbut.setTitle("sin", for: UIControl.State.normal)
            cosbut.setTitle("cos", for: UIControl.State.normal)
            tanbut.setTitle("tan", for: UIControl.State.normal)
            sinhbut.setTitle("sinh", for: UIControl.State.normal)
            coshbut.setTitle("cosh", for: UIControl.State.normal)
            tanhbut.setTitle("tanh", for: UIControl.State.normal)
            specexpbut.setTitle("10^x", for: UIControl.State.normal)
            speclogbut.setTitle("log10", for: UIControl.State.normal)
        }
        secmode = !secmode
    }
    @IBAction func numTouch(_ sender: UIButton) {
        if let btstr = sender.currentTitle{
            if(btstr == "Rad"){
                radModeChange(but : sender)
            }
            else if(btstr == "2nd"){
                secModeChange(but : sender)
            }
            let calstr = cal.parse(str: btstr)
            anslabel.text! = calstr
        }
    }
    
}

