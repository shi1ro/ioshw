//
//  KitManage.swift
//  Final
//
//  Created by njuios on 2021/1/13.
//

import Foundation
import SpriteKit

extension GameScene{
    //nodes manage
    func GameNodesIn(){
        for node in gamenodes{
            self.scene?.addChild(node)
        }
    }
    func GameNodesOut(){
        for node in gamenodes{
            node.removeFromParent()
        }
    }
    func StartNodesIn(){
        for node in startnodes{
            self.scene?.addChild(node)
        }
    }
    func StartNodesOut(){
        for node in startnodes{
            node.removeFromParent()
        }
    }
    func HelpNodesIn(){
        for node in helpnodes{
            self.scene?.addChild(node)
        }
    }
    func HelpNodesOut(){
        for node in helpnodes{
            node.removeFromParent()
        }
    }
    func ClearNodesIn(){
        for node in clearnodes{
            self.scene?.addChild(node)
        }
    }
    func ClearNodesOut(){
        for node in clearnodes{
            node.removeFromParent()
        }
    }
    func enableFuncNode(){
        for index in 0..<funcnodes.count{
            let imagename = functextnames[index]
            funcnodes[index].texture = SKTexture(imageNamed: imagename)
        }
    }
    func disableFuncNode(){
        for index in 0..<funcnodes.count{
            let imagename = funcdistextnames[index]
            funcnodes[index].texture = SKTexture(imageNamed: imagename)
        }
    }
    func initClearNodes(){
        let totalscore = (Double)(timecountdown) * stagescore
        let scoretext1 = SKLabelNode(text:"LeftTime:\(timecountdown)")
        scoretext1.fontSize = 80
        scoretext1.position = CGPoint(x:GameKitPara.scwid/2,y:GameKitPara.schet*2/3)
        scoretext1.fontColor = UIColor.white
        scoretext1.name = KitName.label_clear_tmscore.name
        clearnodes.append(scoretext1)
        let scoretext2 = SKLabelNode(text:"CoreMl Score:\(stagescore)")
        scoretext2.fontSize = 80
        scoretext2.position = CGPoint(x:GameKitPara.scwid/2,y:GameKitPara.schet*2/3 - 150)
        scoretext2.fontColor = UIColor.white
        scoretext2.name = KitName.label_clear_stscore.name
        clearnodes.append(scoretext2)
        let scoretext3 = SKLabelNode(text:"TotalScore:\(totalscore)")
        scoretext3.fontSize = 80
        scoretext3.position = CGPoint(x:GameKitPara.scwid/2,y:GameKitPara.schet*2/3 - 300)
        scoretext3.fontColor = UIColor.white
        scoretext3.name = KitName.label_clear_ttscore.name
        clearnodes.append(scoretext3)
        let scoretext4 = SKLabelNode(text:"TotalScore:\(totalscore)")
        scoretext4.fontSize = 80
        scoretext4.position = CGPoint(x:GameKitPara.scwid/2,y:GameKitPara.schet*2/3 - 450)
        scoretext4.fontColor = UIColor.white
        scoretext4.name = KitName.label_clear_allttscore.name
        clearnodes.append(scoretext4)
        let backtext = SKLabelNode(text:"back")
        backtext.fontSize = CGFloat(Float(70))
        backtext.position = CGPoint(x: GameKitPara.scwid*1/3, y: GameKitPara.schet*1/3 - 300)
        backtext.name = KitName.label_clear_back.name
        clearnodes.append(backtext)
        let nexttext = SKLabelNode(text:"next")
        nexttext.fontSize = CGFloat(Float(70))
        nexttext.position = CGPoint(x: GameKitPara.scwid*2/3, y: GameKitPara.schet*1/3 - 300)
        nexttext.name = KitName.label_clear_next.name
        clearnodes.append(nexttext)
    }
    func updateClearNodes(){
        var totalscore = (Double)(timecountdown) * stagescore
        totalscore = totalscore.roundTo(places: 3)
        alltotalscore += totalscore
        alltotalscore = alltotalscore.roundTo(places: 3)
        for node in clearnodes{
            if let nodename = node.name{
                if nodename == KitName.label_clear_tmscore.name{
                    if let labelnode = node as? SKLabelNode{
                        labelnode.text = "LeftTime:\(timecountdown)"
                    }
                }
                else if nodename == KitName.label_clear_stscore.name{
                    if let labelnode = node as? SKLabelNode{
                        labelnode.text = "CoreMl Score:\(stagescore)"
                    }
                }
                else if nodename == KitName.label_clear_ttscore.name{
                    if let labelnode = node as? SKLabelNode{
                        labelnode.text = "TotalScore:\(totalscore)"
                    }
                }
                else if nodename == KitName.label_clear_allttscore.name{
                    if let labelnode = node as? SKLabelNode{
                        labelnode.text = "AllScore:\(alltotalscore)"
                    }
                }
                else if nodename == KitName.label_clear_back.name{
                    if nowstage == GameKitPara.stagenum{
                        node.position = CGPoint(x: GameKitPara.scwid*1/2, y: GameKitPara.schet*1/3 - 300)
                    }else{
                        node.position = CGPoint(x: GameKitPara.scwid*1/3, y: GameKitPara.schet*1/3 - 300)
                    }
                }
                else if nodename == KitName.label_clear_next.name{
                    node.position = CGPoint(x: GameKitPara.scwid*2/3, y: GameKitPara.schet*1/3 - 300)
                }
            }
        }
    }
    func initHelpNodes(){
        let helptext1 = SKLabelNode(text:"1.游戏目标")
        helptext1.fontSize = 70
        helptext1.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY)
        helptext1.fontColor = UIColor.white
        helptext1.name = KitName.label_help_help.name
        helpnodes.append(helptext1)
        let helptext2 = SKLabelNode(text:"每关会随机产生绘画主题")
        helptext2.fontSize = 50
        helptext2.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY - GameKitPara.helptextitv)
        helptext2.fontColor = UIColor.white
        helptext2.name = KitName.label_help_help.name
        helpnodes.append(helptext2)
        let helptext3 = SKLabelNode(text:"围绕主题进行绘制后,提交给coreml评分")
        helptext3.fontSize = 50
        helptext3.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY - GameKitPara.helptextitv * 2)
        helptext3.fontColor = UIColor.white
        helptext3.name = KitName.label_help_help.name
        helpnodes.append(helptext3)
        let helptext4 = SKLabelNode(text:"时间越快，coreml评分越高，总分越高")
        helptext4.fontSize = 50
        helptext4.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY - GameKitPara.helptextitv * 3)
        helptext4.fontColor = UIColor.white
        helptext4.name = KitName.label_help_help.name
        helpnodes.append(helptext4)
        let helptext5 = SKLabelNode(text:"2.绘画设定")
        helptext5.fontSize = 70
        helptext5.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY - GameKitPara.helptextitv * 4 - 50)
        helptext5.fontColor = UIColor.white
        helptext5.name = KitName.label_help_help.name
        helpnodes.append(helptext5)
        let helptext6 = SKLabelNode(text:"底端会随机产生绘画组件")
        helptext6.fontSize = 50
        helptext6.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY - GameKitPara.helptextitv * 5 - 50)
        helptext6.fontColor = UIColor.white
        helptext6.name = KitName.label_help_help.name
        helpnodes.append(helptext6)
        let helptext7 = SKLabelNode(text:"将其拖入到中心画板完成画作")
        helptext7.fontSize = 50
        helptext7.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY - GameKitPara.helptextitv * 6 - 50)
        helptext7.fontColor = UIColor.white
        helptext7.name = KitName.label_help_help.name
        helpnodes.append(helptext7)
        let helptext8 = SKLabelNode(text:"同时 底端会随机产生星星")
        helptext8.fontSize = 50
        helptext8.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY - GameKitPara.helptextitv * 7 - 50)
        helptext8.fontColor = UIColor.white
        helptext8.name = KitName.label_help_help.name
        helpnodes.append(helptext8)
        let helptext9 = SKLabelNode(text:"点击后 右下角特殊功能按钮变亮")
        helptext9.fontSize = 50
        helptext9.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY - GameKitPara.helptextitv * 8 - 50)
        helptext9.fontColor = UIColor.white
        helptext9.name = KitName.label_help_help.name
        helpnodes.append(helptext9)
        let helptext10 = SKLabelNode(text:"可以进行最多三秒的一笔画")
        helptext10.fontSize = 50
        helptext10.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY - GameKitPara.helptextitv * 9 - 50)
        helptext10.fontColor = UIColor.white
        helptext10.name = KitName.label_help_help.name
        helpnodes.append(helptext10)
        let helptext11 = SKLabelNode(text:"单击组件 可以对其进行移动/旋转/删除")
        helptext11.fontSize = 50
        helptext11.position = CGPoint(x:GameKitPara.scwid / 2,y:GameKitPara.helptextinitY - GameKitPara.helptextitv * 10 - 50)
        helptext11.fontColor = UIColor.white
        helptext11.name = KitName.label_help_help.name
        helpnodes.append(helptext11)
        let backtext = SKLabelNode(text:"back")
        backtext.fontSize = CGFloat(Float(100))
        backtext.position = CGPoint(x: 150, y: GameKitPara.schet - 100)
        backtext.name = KitName.label_help_back.name
        backtext.fontColor = UIColor.red
        helpnodes.append(backtext)
    }
    func initStartNodes(){
        let gamename = SKLabelNode(text: "Draw and Draw!")
        gamename.fontSize = CGFloat(Float(120))
        gamename.position = CGPoint(x: GameKitPara.scwid/2, y: GameKitPara.schet * 3 / 4)
        gamename.fontColor = UIColor.white
        gamename.name = KitName.label_start_gname.name
        startnodes.append(gamename)
        let start = SKLabelNode(text:"Start")
        start.fontSize = CGFloat(Float(100))
        start.position = CGPoint(x: GameKitPara.scwid/2, y: GameKitPara.schet * 1 / 4)
        start.name = KitName.label_start_start.name
        start.fontColor = UIColor.red
        startnodes.append(start)
        let help = SKLabelNode(text:"Help")
        help.fontSize = CGFloat(Float(100))
        help.position = CGPoint(x: GameKitPara.scwid/2, y: GameKitPara.schet / 2)
        help.fontColor = UIColor.red
        help.name = KitName.label_start_help.name
        startnodes.append(help)
    }
    func initGameNodes(){
        let butline1itv = GameKitPara.butwid1+GameKitPara.line1butitv
        let butline2itv = GameKitPara.butwid2+GameKitPara.line2butitv
 //       let but1 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_lr1.imagename)))
        let but1 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_dislr1.imagename)))
        but1.anchorPoint = CGPoint(x: 0, y: 0)
        but1.position = CGPoint(x: butline1itv * 0, y: GameKitPara.butline1Y)
        but1.name = KitName.but_lr1.name
        but1.scale(to: CGSize(width: GameKitPara.butwid1, height: GameKitPara.butwid1))
        gamenodes.append(but1)
        funcnodes.append(but1)
//        let but2 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_lr2.imagename)))
        let but2 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_dislr2.imagename)))
        but2.anchorPoint = CGPoint(x: 0, y: 0)
        but2.position = CGPoint(x: butline1itv * 1, y: GameKitPara.butline1Y)
        but2.name = KitName.but_lr2.name
        but2.scale(to: CGSize(width: GameKitPara.butwid1, height: GameKitPara.butwid1))
        gamenodes.append(but2)
        funcnodes.append(but2)
 //       let but3 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_rr1.imagename)))
        let but3 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_disrr1.imagename)))
        but3.anchorPoint = CGPoint(x: 0, y: 0)
        but3.position = CGPoint(x: butline1itv * 2, y: GameKitPara.butline1Y)
        but3.name = KitName.but_rr1.name
        but3.scale(to: CGSize(width: GameKitPara.butwid1, height: GameKitPara.butwid1))
        gamenodes.append(but3)
        funcnodes.append(but3)
 //       let but4 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_rr2.imagename)))
        let but4 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_disrr2.imagename)))
        but4.anchorPoint = CGPoint(x: 0, y: 0)
        but4.position = CGPoint(x: butline1itv * 3, y: GameKitPara.butline1Y)
        but4.name = KitName.but_rr2.name
        but4.scale(to: CGSize(width: GameKitPara.butwid1, height: GameKitPara.butwid1))
        gamenodes.append(but4)
        funcnodes.append(but4)
 //       let but5 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_cancel.imagename)))
        let but5 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_discancel.imagename)))
        but5.anchorPoint = CGPoint(x: 0, y: 0)
        but5.position = CGPoint(x: butline1itv * 4, y: GameKitPara.butline1Y)
        but5.name = KitName.but_cancel.name
        but5.scale(to: CGSize(width: GameKitPara.butwid1, height: GameKitPara.butwid1))
        gamenodes.append(but5)
        funcnodes.append(but5)
 //       let but6 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_left.imagename)))
        let but6 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_disleft.imagename)))
        but6.anchorPoint = CGPoint(x: 0, y: 0)
        but6.position = CGPoint(x: butline2itv * 0, y: GameKitPara.butline2Y)
        but6.name = KitName.but_left.name
        but6.scale(to: CGSize(width: GameKitPara.butwid2, height: GameKitPara.butwid2))
        gamenodes.append(but6)
        funcnodes.append(but6)
 //       let but7 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_right.imagename)))
        let but7 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_disright.imagename)))
        but7.anchorPoint = CGPoint(x: 0, y: 0)
        but7.position = CGPoint(x: butline2itv * 1, y: GameKitPara.butline2Y)
        but7.name = KitName.but_right.name
        but7.scale(to: CGSize(width: GameKitPara.butwid2, height: GameKitPara.butwid2))
        gamenodes.append(but7)
        funcnodes.append(but7)
//        let but8 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_up.imagename)))
        let but8 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_disup.imagename)))
        but8.anchorPoint = CGPoint(x: 0, y: 0)
        but8.position = CGPoint(x: butline2itv * 2, y: GameKitPara.butline2Y)
        but8.name = KitName.but_up.name
        but8.scale(to: CGSize(width: GameKitPara.butwid2, height: GameKitPara.butwid2))
        gamenodes.append(but8)
        funcnodes.append(but8)
 //       let but9 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_down.imagename)))
        let but9 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_disdown.imagename)))
        but9.anchorPoint = CGPoint(x: 0, y: 0)
        but9.position = CGPoint(x: butline2itv * 3, y: GameKitPara.butline2Y)
        but9.name = KitName.but_down.name
        but9.scale(to: CGSize(width: GameKitPara.butwid2, height: GameKitPara.butwid2))
        gamenodes.append(but9)
        funcnodes.append(but9)
        let but10 = SKSpriteNode(texture: (SKTexture(imageNamed: texture.but_discheat.imagename)))
        but10.anchorPoint = CGPoint(x: 0, y: 0)
        but10.position = CGPoint(x: GameKitPara.drawkidend+50, y: 0)
        but10.scale(to: CGSize(width: GameKitPara.drawkitwid, height: GameKitPara.drawkitwid))
        but10.name = KitName.but_cheat.name
        cheatnode = but10
        gamenodes.append(but10)
        let backtext = SKLabelNode(text: "back")
        backtext.fontSize = CGFloat(Float(GameKitPara.textline2het))
        backtext.position = CGPoint(x: 70, y: GameKitPara.textline2Y)
        backtext.name = KitName.label_game_back.name
        gamenodes.append(backtext)
        let timetext = SKLabelNode(text: "240")
        timetext.fontSize = CGFloat(Float(GameKitPara.textline2het + 30))
        timetext.position = CGPoint(x: GameKitPara.scwid/2, y: GameKitPara.textline2Y)
        timetext.fontColor = UIColor.red
        timetext.name = KitName.label_game_time.name
        self.gametimetext = timetext
        gamenodes.append(timetext)
        let subtext = SKLabelNode(text:"submit")
        subtext.name = KitName.label_game_sub.name
        subtext.fontSize = CGFloat(Float(GameKitPara.textline2het))
        subtext.position = CGPoint(x: GameKitPara.scwid - 90, y: GameKitPara.textline2Y)
        gamenodes.append(subtext)
        let targettext = SKLabelNode(text:"melon")
        targettext.name = KitName.label_game_dt.name
        targettext.fontSize = CGFloat(Float(GameKitPara.textline1het + 30))
        targettext.position = CGPoint(x: GameKitPara.scwid/2, y: GameKitPara.textline1Y)
        targettext.fontColor = UIColor.red
        gamenodes.append(targettext)
        let scoretext = SKLabelNode(text:"0")
        scoretext.name = KitName.label_game_sc.name
        scoretext.fontSize = CGFloat(Float(GameKitPara.textline1het))
        scoretext.position = CGPoint(x: 100, y: GameKitPara.textline1Y)
        gamenodes.append(scoretext)
        let canvas = SKShapeNode(rect: CGRect(x: 0, y: 0, width: GameKitPara.scwid, height: GameKitPara.canvasmaxY-GameKitPara.canvasminY))
        canvasnode = canvas
        canvas.fillColor = UIColor.white
        canvas.name = KitName.canvas.name
        canvas.position = CGPoint(x: 0, y: GameKitPara.canvasminY)
        gamenodes.append(canvas)
    }
}
