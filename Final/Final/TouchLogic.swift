//
//  TouchLogic.swift
//  Final
//
//  Created by njuios on 2021/1/14.
//

import Foundation
import SpriteKit

extension GameScene{
    func checkInCanvas(point:CGPoint)->Bool{
        //if point is in canvas,return true
        if point.y >= CGFloat(GameKitPara.canvasminY),point.y <= CGFloat(GameKitPara.canvasmaxY){
            return true
        }else{
            return false
        }
    }
    func touchDown(atPoint pos : CGPoint) {
/*        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }*/
    }
    
    func touchMoved(toPoint pos : CGPoint) {
/*        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }*/
    }
    
    func touchUp(atPoint pos : CGPoint) {
 /*       if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
/*        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        print("touchesbegin")
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
         (test for fade)
*/
        
        for t in touches{
            /*when a touch begins,save touch->sknode to dictionary
             */
            let location = t.location(in: self)
            let node = self.atPoint(location)
            if let nodename = node.name{
                //print(nodename)
                if !selectedNodes.values.contains(node){
                    selectedNodes[t] = node
                    if gamestate == State.cheat.value,checkInCanvas(point: location){
                        selectedNodes[t] = canvasnode
                        cheatlinepoints.append(location)
                    }
                }
                if nodename == "beginbutton"{
                    //activeDrawKits()
                    //enableFuncNode()
                }
                else if nodename == "endbutton"{
                    //self.time.invalidate()
                    //getimagefromscene()
                    //disableFuncNode()
                    //submit()
                }
            }
            else{
                //print("no name!")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
 //       print("touchesmove")
 //       for t in touches { self.touchMoved(toPoint: t.location(in: self))
//          self.touchUp(atPoint: t.location(in: self))}
        for t in touches {
            /*
             if in game state:
             give drawkit moving animation
             if in cheat value:
             show the current cheat line
             */
            if gamestate == State.game.value{
                if selectedNodes[t] != nil,let beginname = selectedNodes[t]!.name,dk2cvKitNameDic.keys.contains(beginname){
                    let location = t.location(in: self)
                    let movenode = self.atPoint(location)
                    if let movename = movenode.name,movename == KitName.canvas.name{
                        let sknode = getShapeFromName(place: location, linewidth: GameKitPara.canvasKitMoveWidth, name: beginname,mode:0)
                        sknode.run(.sequence([
                            SKAction.wait(forDuration: 0.5),
                            SKAction.fadeOut(withDuration: 0.5),
                            SKAction.removeFromParent()
                        ]))
                        self.addChild(sknode)
                    }
                }
            }
            else if gamestate == State.cheat.value{
                if selectedNodes[t] != nil,let beginname = selectedNodes[t]!.name,beginname == KitName.canvas.name,cheatlinepoints.count != 0{
                    let location = t.location(in: self)
                    if !checkInCanvas(point: location){
                        return
                    }
                    cheatlinepoints.append(location)
                    if tempcheatline != nil{
                        tempcheatline!.removeFromParent()
                    }
                    tempcheatline = createSKLine(points: cheatlinepoints)
                    tempcheatline!.strokeColor = GameKitPara.canvasKitMoveColor
                    tempcheatline!.zPosition = GameKitPara.canvaskitZPo
                    tempcheatline!.name = KitName.cv_cheat.name
                    self.addChild(tempcheatline!)
                }
            }
          

        }
        /*test:            if endnode.name == KitName.canvas.name{
                        if selectedNodes[t] != nil{
                            if let node = selectedNodes[t]{
                                if node.name == "bluerect"{
                                    //print("blue!")
                                    let skcurse = createCurse(place: location)
                                    skcurse.run(.sequence([
                                        SKAction.wait(forDuration: 0.5),
                                        SKAction.fadeOut(withDuration: 0.5),
                                        SKAction.removeFromParent()
                                    ]))
                                    self.addChild(skcurse)
                                }
                                else if node.name == "yellowrect"{
                                    //print("yellow!")
                                }
                                else if node.name == "redrect"{
                                    //print("red!")
                                }
                            }*/
    }
            
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesend")
        for t in touches {
            if selectedNodes[t] != nil,let beginnodename = selectedNodes[t]!.name{
                if dk2cvKitNameDic.keys.contains(beginnodename){
                    canvasnode.zPosition = 1
                    //draw mode,let canvas in the uppest
                }
            }
            let location = t.location(in: self)
            let endnode = self.atPoint(location)
            if let endnodename = endnode.name{
                //print(endnodename)
                if gamestate == State.start.value{
                    if endnodename == KitName.label_start_help.name{
                        gamestate = State.help.value
                    }
                    else if endnodename == KitName.label_start_start.name{
                        gamestate = State.game.value
                    }
                }
                else if gamestate == State.help.value{
                    if endnodename == KitName.label_help_back.name{
                        gamestate = State.start.value
                    }
                }
                else if gamestate == State.cheat.value{
                    if selectedNodes[t] != nil,let beginname = selectedNodes[t]!.name,beginname == KitName.canvas.name,checkInCanvas(point: location),cheatlinepoints.count != 0{
                        cheatlinepoints.append(location)
                        gamestate = State.game.value
                    }
                }
                else if gamestate == State.game.value{
                    if endnodename == KitName.label_game_back.name{
                        gamestate = State.start.value
                    }
                    else if endnodename == KitName.label_game_sub.name{
                        submit()
                    }
                    else if endnodename == KitName.dk_star.name{
                        cheatable = true
                        endnode.removeFromParent()
                    }
                    else if endnodename == KitName.but_cheat.name{
                        if cheatable{
                            cheatable = false
                            gamestate = State.cheat.value
                        }
                    }
                    else if selectedNodes[t] != nil, let beginnodename = selectedNodes[t]!.name{
                        if endnodename == KitName.canvas.name{
                            if dk2cvKitNameDic.keys.contains(beginnodename){
                                //add drawkit into canvas
                                let sknode = getShapeFromName(place: location, linewidth: GameKitPara.canvasKitWidth, name: beginnodename,mode:1)
                                self.scene?.addChild(sknode)
                                //drawnodes.append(sknode)
                                EnterAdjustMode(cvnode: sknode)
                            }
                            else{
                                ExitAdjustMode()
                            }
                        }
                        else if dk2cvKitNameDic.values.contains(endnodename) || endnodename == KitName.cv_cheat.name{
                            //click canvas shape node,enter shape adjust mode
                            EnterAdjustMode(cvnode: endnode)
                        }
                        else if funcKitNames.contains(endnodename){
                            //click shape function button,adjust shape
                            adjustShapeFromBut(butnode: endnode)
                        }
                        else{
                            //exit shape adjust mode
                            ExitAdjustMode()
                        }
                    }
                }
                else if gamestate == State.clear.value{
                    if endnodename == KitName.label_clear_back.name{
                        gamestate = State.start.value
                    }
                    else if endnodename == KitName.label_clear_next.name{
                        gamestate = State.game.value
                    }
                }
            }
            
            if selectedNodes[t] != nil{
                selectedNodes[t] = nil
            }
            canvasnode.zPosition = 0
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
       // print(currentTime)
    }
}
