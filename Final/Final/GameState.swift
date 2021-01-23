//
//  GameState.swift
//  Final
//
//  Created by njuios on 2021/1/13.
//

import Foundation
import SpriteKit

extension GameScene{
    
    func EnterGame(){
        gamestate = State.start.value
        StartNodesIn()
    }
    func EnterHelpScene(){
        HelpNodesIn()
        print("EnterHelpScene")
    }
    func ExitHelpScene(){
        HelpNodesOut()
        print("ExitHelpScene")
    }
    func EnterStartScene(){
        StartNodesIn()
        print("EnterStartScene")
    }
    func ExitStartScene(){
        StartNodesOut()
        print("ExitStartScene")
    }
    func EnterGameScene(){
        drawindex = Int.random(in: 0..<detectlabels.count)
        timecountdown = GameKitPara.initTime
        GameNodesIn()
        if let node = scene?.childNode(withName: KitName.label_game_dt.name){
            if let labelnode = node as? SKLabelNode{
                labelnode.text = "\(nowstage):\(detectlabels[drawindex])"
            }
        }
        activeDrawKits()
        print("EnterGameScene")
    }
    func ExitGameScene(){
        time.invalidate()
        self.scene?.removeAllChildren()
        GameNodesOut()
        print("ExitGameScene")
    }
    func EnterClearScene(){
        updateClearNodes()
        ClearNodesIn()
        if nowstage == GameKitPara.stagenum{
            if let node = scene?.childNode(withName: KitName.label_clear_next.name){
                node.removeFromParent()
            }
        }
        
        print("EnterClearScene")
    }
    func ExitClearScene(){
        ClearNodesOut()
        print("ExitClearScene")
    }
    func EnterCheatScene(){
        var countDownNum = 3
        time1 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countDownNum == 0 {
                timer.invalidate()
                if self.gamestate == State.cheat.value{
                    self.gamestate = State.game.value
                }
            } else {
                countDownNum -= 1
            }
        }
    }
    func ExitCheatScene(){
        tempcheatline = nil
        cheatlinepoints = [CGPoint]()
    }
    func EnterAdjustMode(cvnode:SKNode){
        if nowcvnode != nil,let shapenode = nowcvnode as? SKShapeNode{
            shapenode.strokeColor = GameKitPara.canvasKitColor
        }
        nowcvnode = cvnode
        if let shapenode = cvnode as? SKShapeNode{
            shapenode.strokeColor = GameKitPara.canvasKitAdjustColor
        }
        enableFuncNode()
    }
    func ExitAdjustMode(){
        if let shapenode = nowcvnode as? SKShapeNode{
            shapenode.strokeColor = GameKitPara.canvasKitColor
        }
        nowcvnode = nil
        disableFuncNode()
    }
    func initGameValue(){
        nowstage = 1
        stagescore = 0
        alltotalscore = 0
        nowcvnode = nil
        tempcheatline = nil
        cheatlinepoints.removeAll()
    }
}
