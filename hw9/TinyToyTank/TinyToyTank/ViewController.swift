//
//  ViewController.swift
//  TinyToyTank
//
//  Created by njuios on 2021/1/7.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arView: ARView!
    var tankAnchor:TinyToyTank._TinyToyTank?
    var isActionPlaying: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        tankAnchor = try! TinyToyTank.load_TinyToyTank()
        arView.scene.anchors.append(tankAnchor!)
        tankAnchor?.cannon?.setParent(tankAnchor?.tank,preservingWorldTransform: true)
        tankAnchor?.actions.actionComplete.onAction = { _ in
          self.isActionPlaying = false
        }
    }
    
    @IBAction func TurrentRightTap(_ sender: UIButton) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }
        tankAnchor!.notifications.turretRight.post()
    }
    
    @IBAction func TurrentLeftTap(_ sender: UIButton) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }
        tankAnchor!.notifications.turretLeft.post()
    }
    
    @IBAction func FIreTap(_ sender: UIButton) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }
        tankAnchor!.notifications.cannonFire.post()
    }
    
    @IBAction func TankLeftTap(_ sender: UIButton) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }
        tankAnchor!.notifications.tankLeft.post()
    }
    
    @IBAction func TankForwardTap(_ sender: UIButton) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }
        tankAnchor!.notifications.tankForward.post()
    }
    
    @IBAction func TankRightTap(_ sender: Any) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }
        tankAnchor!.notifications.tankRight.post()
    }
}
