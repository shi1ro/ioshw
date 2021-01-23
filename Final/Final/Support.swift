//
//  KitName.swift
//  Final
//
//  Created by njuios on 2021/1/10.
//

import Foundation
import SpriteKit
enum KitName: String{
    case but_lr1 = "leftro1"
    case but_lr2 = "leftro2"
    case but_rr1 = "rightro1"
    case but_rr2 = "rightro2"
    case but_cancel = "cancel"
    case but_up = "up"
    case but_down = "down"
    case but_left = "left"
    case but_right = "right"
    case but_cheat = "cheat"
    case but_discheat = "discheat"
    case label_game_dt = "gdrawtarget"
    case label_game_sc = "gscore"
    case label_game_sub = "gsubmit"
    case label_game_back = "gback"
    case label_game_time = "gtime"
    case label_start_gname = "sdrawanddraw"
    //gamename
    case label_start_start = "sstart"
    case label_start_help = "shelp"
    case label_help_back = "hback"
    case label_help_help = "hhelp"
    case label_clear_back = "cback"
    case label_clear_next = "cnext"
    case label_clear_stscore = "cstscore"
    //stage score
    case label_clear_tmscore = "ctmscore"
    //time score
    case label_clear_ttscore = "cttscore"
    //total score = timescore * stagescore
    case label_clear_allttscore = "callttscore"
    //all stage total score
    case but_beg = "beginbutton"
    case but_end = "endbutton"
    case canvas = "canvas"
    
    case dk_line1 = "line1"//moving draw kit
    case dk_line2 = "line2"
    case dk_line3 = "line3"
    case dk_line4 = "line4"
    case dk_arch1 = "arch1"
    case dk_arch2 = "arch2"
    case dk_arch3 = "arch3"
    case dk_arch4 = "arch4"
    case dk_qc1 = "qcircle1"//quarter circle
    case dk_qc2 = "qcircle2"
    case dk_qc3 = "qcircle3"
    case dk_qc4 = "qcircle4"
    case dk_circle = "circle"
    case dk_bridge1 = "bridge1"
    case dk_bridge2 = "bridge2"
    case dk_halftri1 = "halftri1"
    case dk_halftri2 = "halftri2"
    case dk_star = "star"
    
    case cv_line1 = "linec1"//in canvas
    case cv_line2 = "linec2"
    case cv_line3 = "linec3"
    case cv_line4 = "linec4"
    case cv_arch1 = "archc1"
    case cv_arch2 = "archc2"
    case cv_arch3 = "archc3"
    case cv_arch4 = "archc4"
    case cv_qc1 = "qcirclec1"//quarter circle
    case cv_qc2 = "qcirclec2"
    case cv_qc3 = "qcirclec3"
    case cv_qc4 = "qcirclec4"
    case cv_circle = "circlec"
    case cv_bridge1 = "bridgec1"
    case cv_bridge2 = "bridgec2"
    case cv_halftri1 = "halftric1"
    case cv_halftri2 = "halftric2"
    case cv_cheat = "cheatline"
    var name: String{
        return rawValue
    }
}
enum texture:String{
    //dk:draw kit,but:button
    case dk_line1 = "line1"
    case dk_line2 = "line2"
    case dk_line3 = "line3"
    case dk_line4 = "line4"
    case dk_arch1 = "arch1"
    case dk_arch2 = "arch2"
    case dk_arch3 = "arch3"
    case dk_arch4 = "arch4"
    case dk_qc1 = "qcircle1"//quarter circle
    case dk_qc2 = "qcircle2"
    case dk_qc3 = "qcircle3"
    case dk_qc4 = "qcircle4"
    case dk_circle = "circle"
    case dk_bridge1 = "bridge1"
    case dk_bridge2 = "bridge2"
    case dk_halftri1 = "halftri1"
    case dk_halftri2 = "halftri2"
    case dk_star = "star"
    case but_up = "up"
    case but_disup = "disup"
    case but_down = "down"
    case but_disdown = "disdown"
    case but_left = "left"
    case but_disleft = "disleft"
    case but_right = "right"
    case but_disright = "disright"
    case but_cancel = "cancel"
    case but_discancel = "discancel"
    case but_lr1 = "lr1"
    case but_dislr1 = "dislr1"
    case but_lr2 = "lr2"
    case but_dislr2 = "dislr2"
    case but_rr1 = "rr1"
    case but_disrr1 = "disrr1"
    case but_rr2 = "rr2"
    case but_disrr2 = "disrr2"
    case but_cheat = "cheat"
    case but_discheat = "discheat"
    var imagename:String{
        return rawValue
    }
}
let funcKitNames:[String] = [
    KitName.but_lr1.name,
    KitName.but_lr2.name,
    KitName.but_rr1.name,
    KitName.but_rr2.name,
    KitName.but_cancel.name,
    KitName.but_up.name,
    KitName.but_down.name,
    KitName.but_left.name,
    KitName.but_right.name,
]

let dk2cvKitNameDic:[String:String] = [
    KitName.dk_line1.name : KitName.cv_line1.name,
    KitName.dk_line2.name : KitName.cv_line2.name,
    KitName.dk_line3.name : KitName.cv_line3.name,
    KitName.dk_line4.name : KitName.cv_line4.name,
    KitName.dk_qc1.name : KitName.cv_qc1.name,
    KitName.dk_qc2.name : KitName.cv_qc2.name,
    KitName.dk_qc3.name : KitName.cv_qc3.name,
    KitName.dk_qc4.name : KitName.cv_qc4.name,
    KitName.dk_arch1.name : KitName.cv_arch1.name,
    KitName.dk_arch2.name : KitName.cv_arch2.name,
    KitName.dk_arch3.name : KitName.cv_arch3.name,
    KitName.dk_arch4.name : KitName.cv_arch4.name,
    KitName.dk_circle.name : KitName.cv_circle.name,
    KitName.dk_bridge1.name : KitName.cv_bridge1.name,
    KitName.dk_bridge2.name : KitName.cv_bridge2.name,
    KitName.dk_halftri1.name : KitName.cv_halftri1.name,
    KitName.dk_halftri2.name : KitName.cv_halftri2.name,
    KitName.dk_star.name : KitName.dk_star.name
]
let functextnames:[String] = [
    texture.but_lr1.imagename,
    texture.but_lr2.imagename,
    texture.but_rr1.imagename,
    texture.but_rr2.imagename,
    texture.but_cancel.imagename,
    texture.but_left.imagename,
    texture.but_right.imagename,
    texture.but_up.imagename,
    texture.but_down.imagename
]
let funcdistextnames:[String] = [
    texture.but_dislr1.imagename,
    texture.but_dislr2.imagename,
    texture.but_disrr1.imagename,
    texture.but_disrr2.imagename,
    texture.but_discancel.imagename,
    texture.but_disleft.imagename,
    texture.but_disright.imagename,
    texture.but_disup.imagename,
    texture.but_disdown.imagename
]


enum State:Int{
    case clear = -2
    case help = -1
    case start = 0
    case game = 1
    case cheat = 2
    var value:Int{
        return rawValue
    }
}

enum DrawKitPara:Int{
    case line1 = 100
    var value:Int{
        return rawValue
    }
}

/*let DrawKitNameArr = [String](
arrayLiteral:
    texture.dk_line1.imagename,
    texture.dk_line2.imagename,
    texture.dk_line3.imagename,
    texture.dk_line4.imagename,
    texture.dk_arch1.imagename,
    texture.dk_arch2.imagename,
    texture.dk_arch3.imagename,
    texture.dk_arch4.imagename,
    texture.dk_qc1.imagename,
    texture.dk_qc2.imagename,
    texture.dk_qc3.imagename,
    texture.dk_qc4.imagename,
    texture.dk_circle.imagename,
    texture.dk_bridge1.imagename,
    texture.dk_bridge2.imagename
)*/
class GameKitPara{
    static let butwid1 = 100
    static let butwid2 = 125
    static let dkwid = 150
    static let line1butnum = 5
    static let line2butnum = 4
    static let scwid = 900
    static let schet = 1600
    static let betweenlineitv = 40
    static let dkscale = 1.0
    static let line1wid = butwid1
    static let line2wid = butwid2
    static let line1butitv = (scwid-line1wid*line1butnum)/(line1butnum-1)
    static let line2butitv = (scwid-line2wid*line2butnum)/(line2butnum-1)
    static let butline1Y = schet-line1wid-betweenlineitv
    static let butline2Y = butline1Y - line2wid - betweenlineitv
    static let drawkitwid = Int(Double(dkwid)*dkscale)
    static let drawkidend = scwid - drawkitwid - 50
    static let textline1Y = drawkitwid + betweenlineitv + 20
    static let textline1het = 70
    static let textline2het = 70
    static let textline2Y = schet - line1wid - line2wid - 3*betweenlineitv - textline2het
    static let canvasminY = textline1Y+textline1het+betweenlineitv
    static let canvasmaxY = textline2Y-betweenlineitv
    static let helptextitv = 70
    static let helptextinitY = schet - 300
    
    static let canvasKitWidth = CGFloat(15.0)
    static let canvasKitMoveWidth = CGFloat(5.0)
    static let canvasKitColor = UIColor.black
    static let canvasKitMoveColor = UIColor.gray
    static let canvasKitAdjustColor = UIColor.red
    static let linelength = CGFloat(100)
    static let qcircleradius = CGFloat(50)
    static let canvaskitZPo = CGFloat(0.5)
    static let archwidth = CGFloat(30)
    static let archlength = CGFloat(100)
    static let bridgewidth = CGFloat(50)
    static let bridgeheight = CGFloat(30)
    static let circleradius = CGFloat(50)
    static let triwidth = CGFloat(50)
    static let triheight = CGFloat(triwidth * sqrt(3) / 2)
    static let stardura = TimeInterval(1.5)
    static let kitdura = TimeInterval(2.5)
    static let initTime = 500
    
    static let stagenum = 3
}

let detectlabels = ["apple",
                    "banana",
                    "cake",
                    "candy",
                    "carrot",
                    "cookie",
                    "doughnut",
                    "grape",
                    "hot dog",
                    "ice cream",
                    "juice",
                    "muffin",
                    "orange",
                    "pineapple",
                    "popcorn",
                    "pretzel",
                    "salad",
                    "strawberry",
                    "waffle",
                    "watermelon"]
