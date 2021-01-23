//
//  GameViewController.swift
//  Final
//
//  Created by njuios on 2021/1/9.
//

import UIKit
import SpriteKit
import GameplayKit
class GameViewController: UIViewController {

   
    @IBOutlet var skview: SKView!
    var ciimage = CIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                // Present the scene
                skview.presentScene(scene)
            
            skview.ignoresSiblingOrder = true
//            skview.showsFPS = true
//            skview.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
