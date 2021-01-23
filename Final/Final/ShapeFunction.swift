//
//  ShapeFunction.swift
//  Final
//
//  Created by njuios on 2021/1/13.
//

import Foundation
import Foundation
import SpriteKit

extension GameScene{
    func createSKCircle(points:[CGPoint])->SKShapeNode{
        if points.count != 1{
            return SKShapeNode()
        }
        var skcircle:SKShapeNode
        let center = points[0]
        let bezcir = UIBezierPath(arcCenter: center, radius: GameKitPara.circleradius, startAngle: 0, endAngle: -0.00001, clockwise: true)
        skcircle = SKShapeNode(path: bezcir.cgPath)
        return skcircle
    }
    func createSKCurve(points:[CGPoint])->SKShapeNode{
        if points.count <= 2{
            return SKShapeNode()
        }
        let curve = UIBezierPath()
        var skcurve:SKShapeNode
        curve.move(to: points[0])
        for index in 1 ..< points.count{
            //index-1 -> index
            let pi = points[index-1]
            let pim1:CGPoint
            //p_i-1 minus
            if index == 1{
                pim1 = points[index-1]
            }
            else{
                pim1 = points[index-2]
            }
            let pip1 = points[index]
            //p_i+1 plus
            let pip2:CGPoint
            if index == points.count - 1{
                pip2 = points[index]
            }
            else{
                pip2 = points[index+1]
            }
            let control1x = pi.x + (pip1.x - pim1.x) / 4
            //xi + (xi+1 - xi-1) / 4
            let control1y = pi.y + (pip1.y - pim1.y) / 4
            //yi + (yi+1 - yi-1) / 4
            let control2x = pip1.x - (pip2.x - pi.x) / 4
            //xi+1 - (xi+2 - xi) / 4
            let control2y = pip1.y - (pip2.y - pi.y) / 4
            //yi+1 - (yi+2 - yi) / 4
            curve.addCurve(to: pip1, controlPoint1: CGPoint(x:control1x,y:control1y), controlPoint2: CGPoint(x:control2x,y:control2y))
        }
        skcurve = SKShapeNode(path: curve.cgPath)
        return skcurve
    }
    func createSKQcircle(points:[CGPoint])->SKShapeNode{
        if points.count != 2{
            print("createSKQcircle eror")
            return SKShapeNode()
        }
        var skqc:SKShapeNode
        let center = points[0]
        let start = points[1].x
        let end = points[1].y
        let bezcir = UIBezierPath(arcCenter: center, radius: GameKitPara.qcircleradius, startAngle: start, endAngle: end, clockwise: true)
        skqc = SKShapeNode(path: bezcir.cgPath)
        return skqc
    }
    func createSKLine(points:[CGPoint])->SKShapeNode{
        if points.count < 2{
            print("createSKline eror")
            return SKShapeNode()
        }
        var skline:SKShapeNode
        let path = UIBezierPath()
        path.move(to:points[0])
        for index in 1..<points.count{
            path.addLine(to: points[index])
        }
        skline = SKShapeNode(path: path.cgPath)
        return skline
    }
    func createEnd(cvnode:SKShapeNode,linewidth:CGFloat,points:[CGPoint],kind:String,mode:Int){
        cvnode.lineWidth = linewidth
        cvnode.zPosition = GameKitPara.canvaskitZPo
        if dk2cvKitNameDic[kind] == nil{
            cvnode.name = kind
        }else{
            cvnode.name = dk2cvKitNameDic[kind]!
        }
        if mode == 0{
            cvnode.strokeColor = GameKitPara.canvasKitMoveColor
        }
        else if mode == 1{
            cvnode.strokeColor = GameKitPara.canvasKitColor
            drawnodes[cvnode] = points
        }
    }
    func createLine(place:CGPoint,length:CGFloat,linewidth:CGFloat,kind:String,mode:Int)->SKShapeNode{
        var skline:SKShapeNode
        var points = [CGPoint]()
        if kind == KitName.dk_line1.name{
            points.append(CGPoint(x:place.x,y:place.y-length/2))
            points.append(CGPoint(x:place.x,y:place.y+length/2))
        }
        else if kind == KitName.dk_line2.name{
            points.append(CGPoint(x:place.x-length/2,y:place.y))
            points.append(CGPoint(x:place.x+length/2,y:place.y))
        }
        else if kind == KitName.dk_line3.name{
            points.append(CGPoint(x:place.x-length*sqrt(2)/4,y:place.y-length*sqrt(2)/4))
            points.append(CGPoint(x:place.x+length*sqrt(2)/4,y:place.y+length*sqrt(2)/4))
        }
        else if kind == KitName.dk_line4.name{
            points.append(CGPoint(x:place.x-length*sqrt(2)/4,y:place.y+length*sqrt(2)/4))
            points.append(CGPoint(x:place.x+length*sqrt(2)/4,y:place.y-length*sqrt(2)/4))
        }
        skline = createSKLine(points:points)
        /*skline.lineWidth = linewidth
        skline.zPosition = GameKitPara.canvaskitZPo
        skline.name = dk2cvKitNameDic[kind]!
        if mode == 0{
            skline.strokeColor = GameKitPara.canvasKitMoveColor
        }
        else if mode == 1{
            skline.strokeColor = GameKitPara.canvasKitColor
            drawnodes[skline] = points
        }*/
        createEnd(cvnode:skline,linewidth:linewidth,points:points,kind:kind,mode:mode)
        return skline
    }
    func createHalfTri(place:CGPoint,linewidth:CGFloat,kind:String,mode:Int)->SKShapeNode{
        var points = [CGPoint]()
        if kind == KitName.dk_halftri1.name{
            points.append(CGPoint(x:place.x - GameKitPara.triwidth,y:place.y))
            points.append(CGPoint(x:place.x,y:place.y+GameKitPara.triheight))
            points.append(CGPoint(x:place.x + GameKitPara.triwidth,y:place.y))
        }
        else if kind == KitName.dk_halftri2.name{
            points.append(CGPoint(x:place.x - GameKitPara.triwidth,y:place.y))
            points.append(CGPoint(x:place.x,y:place.y-GameKitPara.triheight))
            points.append(CGPoint(x:place.x + GameKitPara.triwidth,y:place.y))
        }
        let sktri = createSKLine(points:points)
        createEnd(cvnode:sktri,linewidth:linewidth,points:points,kind:kind,mode:mode)
        return sktri
    }
    func createQcircle(place:CGPoint,linewidth:CGFloat,kind:String,mode:Int)->SKShapeNode{
        var points = [CGPoint]()
        points.append(place)
        if kind == KitName.dk_qc1.name{
            points.append(CGPoint(x: 0, y: Double.pi/2))
        }
        else if kind == KitName.dk_qc2.name{
            points.append(CGPoint(x:Double.pi / 2,y:Double.pi))
        }
        else if kind == KitName.dk_qc3.name{
            points.append(CGPoint(x:Double.pi,y:Double.pi * 3 / 2))
        }
        else if kind == KitName.dk_qc4.name{
            points.append(CGPoint(x:Double.pi * 3 / 2,y:0))
        }
        let skqc = createSKQcircle(points: points)
        createEnd(cvnode:skqc,linewidth:linewidth,points:points,kind:kind,mode:mode)
        return skqc
    }
    func createArch(place:CGPoint,linewidth:CGFloat,kind:String,mode:Int)->SKShapeNode{
        var points = [CGPoint]()
        if kind == KitName.dk_arch1.name{
            points.append(CGPoint(x: place.x, y: place.y + GameKitPara.archwidth))
            points.append(CGPoint(x: place.x - GameKitPara.archlength,y:place.y))
            points.append(CGPoint(x: place.x, y: place.y - GameKitPara.archwidth))
        }
        else if kind == KitName.dk_arch2.name{
            points.append(CGPoint(x: place.x - GameKitPara.archwidth, y: place.y))
            points.append(CGPoint(x: place.x,y:place.y - GameKitPara.archlength))
            points.append(CGPoint(x: place.x + GameKitPara.archwidth, y: place.y))
        }
        else if kind == KitName.dk_arch3.name{
            points.append(CGPoint(x: place.x, y: place.y + GameKitPara.archwidth))
            points.append(CGPoint(x: place.x + GameKitPara.archlength,y:place.y))
            points.append(CGPoint(x: place.x, y: place.y - GameKitPara.archwidth))
        }
        else if kind == KitName.dk_arch4.name{
            points.append(CGPoint(x: place.x - GameKitPara.archwidth, y: place.y))
            points.append(CGPoint(x: place.x,y:place.y + GameKitPara.archlength))
            points.append(CGPoint(x: place.x + GameKitPara.archwidth, y: place.y))
        }
        let skarch = createSKCurve(points: points)
        createEnd(cvnode:skarch,linewidth:linewidth,points:points,kind:kind,mode:mode)
        return skarch
    }
    func createBridge(place:CGPoint,linewidth:CGFloat,kind:String,mode:Int)->SKShapeNode{
        var points = [CGPoint]()
        if kind == KitName.dk_bridge1.name{
            points.append(CGPoint(x: place.x - GameKitPara.bridgewidth, y: place.y))
            points.append(CGPoint(x: place.x,y:place.y + GameKitPara.bridgeheight))
            points.append(CGPoint(x: place.x + GameKitPara.bridgewidth, y: place.y))
        }
        else if kind == KitName.dk_bridge2.name{
            points.append(CGPoint(x: place.x - GameKitPara.bridgewidth, y: place.y))
            points.append(CGPoint(x: place.x,y:place.y - GameKitPara.bridgeheight))
            points.append(CGPoint(x: place.x + GameKitPara.bridgewidth, y: place.y))
        }
        let skbridge = createSKCurve(points: points)
        createEnd(cvnode:skbridge,linewidth:linewidth,points:points,kind:kind,mode:mode)
        return skbridge
    }
    func createCircle(place:CGPoint,linewidth:CGFloat,kind:String,mode:Int)->SKShapeNode{
        var points = [CGPoint]()
        if kind == KitName.dk_circle.name{
            points.append(CGPoint(x: place.x, y: place.y))
        }
        let skcircle = createSKCircle(points: points)
        createEnd(cvnode:skcircle,linewidth:linewidth,points:points,kind:kind,mode:mode)
        return skcircle
    }
    func cvnodeMove(cvnode:SKNode,movevec:CGPoint){
        cvnode.position.x = cvnode.position.x + movevec.x
        cvnode.position.y = cvnode.position.y + movevec.y
    }
    func cheatMove(cvnode:SKNode,movevec:CGPoint){
        var newpoints = [CGPoint]()
        if let points = drawnodes[cvnode]{
            for point in points{
                let newpoint = CGPoint(x:point.x + movevec.x,y:point.y+movevec.y)
                newpoints.append(newpoint)
                drawnodes[cvnode] = newpoints
            }
        }
    }
    func lineMove(cvnode:SKNode,movevec:CGPoint){
        var newpoints = [CGPoint]()
        if let points = drawnodes[cvnode]{
            for point in points{
                let newpoint = CGPoint(x:point.x + movevec.x,y:point.y+movevec.y)
                newpoints.append(newpoint)
                drawnodes[cvnode] = newpoints
            }
        }
    }
    func triMove(cvnode:SKNode,movevec:CGPoint){
        var newpoints = [CGPoint]()
        if let points = drawnodes[cvnode]{
            for point in points{
                let newpoint = CGPoint(x:point.x + movevec.x,y:point.y+movevec.y)
                newpoints.append(newpoint)
                drawnodes[cvnode] = newpoints
            }
        }
    }
    func archMove(cvnode:SKNode,movevec:CGPoint){
        var newpoints = [CGPoint]()
        if let points = drawnodes[cvnode]{
            for point in points{
                let newpoint = CGPoint(x:point.x + movevec.x,y:point.y+movevec.y)
                newpoints.append(newpoint)
                drawnodes[cvnode] = newpoints
            }
        }
    }
    func bridgeMove(cvnode:SKNode,movevec:CGPoint){
        var newpoints = [CGPoint]()
        if let points = drawnodes[cvnode]{
            for point in points{
                let newpoint = CGPoint(x:point.x + movevec.x,y:point.y+movevec.y)
                newpoints.append(newpoint)
                drawnodes[cvnode] = newpoints
            }
        }
    }
    func qcircleMove(cvnode:SKNode,movevec:CGPoint){
        var newpoints = [CGPoint]()
        if let points = drawnodes[cvnode]{
            let center = points[0]
            let newcenter = CGPoint(x:center.x + movevec.x,y:center.y + movevec.y)
            let angle = points[1]
            newpoints.append(newcenter)
            newpoints.append(angle)
            drawnodes[cvnode] = newpoints
        }
    }
    func circleMove(cvnode:SKNode,movevec:CGPoint){
        var newpoints = [CGPoint]()
        if let points = drawnodes[cvnode]{
            let center = points[0]
            let newcenter = CGPoint(x:center.x + movevec.x,y:center.y + movevec.y)
            newpoints.append(newcenter)
            drawnodes[cvnode] = newpoints
        }
    }

    func shapeMove(cvnode:SKNode,movevec:CGPoint){
        cvnodeMove(cvnode: cvnode, movevec: movevec)
        if let cvname = cvnode.name{
            if cvname.hasPrefix("line"){
                lineMove(cvnode: cvnode, movevec:movevec)
            }
            else if cvname.hasPrefix("arch"){
                archMove(cvnode: cvnode, movevec:movevec)
            }
            else if cvname.hasPrefix("bridge"){
                bridgeMove(cvnode: cvnode, movevec:movevec)
            }
            else if cvname.hasPrefix("qcircle"){
                qcircleMove(cvnode: cvnode, movevec:movevec)
            }
            else if cvname.hasPrefix("circle"){
                circleMove(cvnode: cvnode, movevec:movevec)
            }
            else if cvname.hasPrefix("halftri"){
                triMove(cvnode: cvnode, movevec: movevec)
            }
            else if cvname.hasPrefix("cheat"){
                cheatMove(cvnode: cvnode, movevec: movevec)
            }
        }
    }
    func shapeFunc_Up(cvnode:SKNode){
        shapeMove(cvnode: cvnode, movevec: CGPoint(x:0,y:5))
    }
    func shapeFunc_Down(cvnode:SKNode){
        shapeMove(cvnode: cvnode, movevec: CGPoint(x:0,y:-5))
    }
    func shapeFunc_Left(cvnode:SKNode){
        shapeMove(cvnode: cvnode, movevec: CGPoint(x:-5,y:0))
    }
    func shapeFunc_Right(cvnode:SKNode){
        shapeMove(cvnode: cvnode, movevec: CGPoint(x:5,y:0))
    }
    func rotateEnd(orinode:SKNode,newnode:SKShapeNode,ropoints:[CGPoint]){
        newnode.lineWidth = GameKitPara.canvasKitWidth
        newnode.zPosition = GameKitPara.canvaskitZPo
        newnode.name = orinode.name
        newnode.strokeColor = GameKitPara.canvasKitAdjustColor
        orinode.removeFromParent()
        self.addChild(newnode)
        drawnodes[orinode] = nil
        drawnodes[newnode] = ropoints
        nowcvnode = newnode
    }
    func cheatRotate(cvnode:SKNode,angle:Double){
        if drawnodes[cvnode] != nil,let shapepoints = drawnodes[cvnode]{
            let center = calCenter(points: shapepoints)
            let ropoints = calPointsRotate(points: shapepoints, center: center, angle: angle)
            let newskline = createSKLine(points: ropoints)
            rotateEnd(orinode: cvnode, newnode: newskline, ropoints: ropoints)
        }
    }
    func lineRotate(cvnode:SKNode,angle:Double){
        if drawnodes[cvnode] != nil,let shapepoints = drawnodes[cvnode]{
            let center = calCenter(points: shapepoints)
            let ropoints = calPointsRotate(points: shapepoints, center: center, angle: angle)
            let newskline = createSKLine(points: ropoints)
            rotateEnd(orinode: cvnode, newnode: newskline, ropoints: ropoints)
        }
    }
    func triRotate(cvnode:SKNode,angle:Double){
        if drawnodes[cvnode] != nil,let shapepoints = drawnodes[cvnode]{
            let center = calCenter(points: shapepoints)
            let ropoints = calPointsRotate(points: shapepoints, center: center, angle: angle)
            let newskline = createSKLine(points: ropoints)
            rotateEnd(orinode: cvnode, newnode: newskline, ropoints: ropoints)
        }
    }
    func archRotate(cvnode:SKNode,angle:Double){
        if drawnodes[cvnode] != nil,let shapepoints = drawnodes[cvnode]{
            let center = calCenter(points: shapepoints)
            let ropoints = calPointsRotate(points: shapepoints, center: center, angle: angle)
            let newskcurve = createSKCurve(points: ropoints)
            rotateEnd(orinode: cvnode, newnode: newskcurve, ropoints: ropoints)
        }
    }
    func bridgeRotate(cvnode:SKNode,angle:Double){
        if drawnodes[cvnode] != nil,let shapepoints = drawnodes[cvnode]{
            let center = calCenter(points: shapepoints)
            let ropoints = calPointsRotate(points: shapepoints, center: center, angle: angle)
            let newskcurve = createSKCurve(points: ropoints)
            rotateEnd(orinode: cvnode, newnode: newskcurve, ropoints: ropoints)
        }
    }
    func qcircleRotate(cvnode:SKNode,angle:Double){
        if drawnodes[cvnode] != nil,let shapepoints = drawnodes[cvnode]{
            let center = shapepoints[0]
            let robegin = shapepoints[1].x + CGFloat(angle)
            let roend = shapepoints[1].y + CGFloat(angle)
            let roangle = CGPoint(x:robegin,y:roend)
            var ropoints = [CGPoint]()
            ropoints.append(center)
            ropoints.append(roangle)
            let roskqc = createSKQcircle(points: ropoints)
 /*         roskqc.name = cvnode.name
            roskqc.lineWidth = GameKitPara.canvasKitWidth
            roskqc.zPosition = GameKitPara.canvaskitZPo
            roskqc.strokeColor = GameKitPara.canvasKitAdjustColor
            cvnode.removeFromParent()
            self.addChild(roskqc)
            drawnodes[cvnode] = nil
            drawnodes[roskqc] = ropoints
            nowcvnode = roskqc*/
            rotateEnd(orinode: cvnode, newnode: roskqc, ropoints: ropoints)
        }
    }
    func shapeRotate(cvnode:SKNode,angle:Double){
        if let cvname = cvnode.name{
            if cvname.hasPrefix("line"){
                lineRotate(cvnode: cvnode, angle: angle)
            }
            else if cvname.hasPrefix("arch"){
                archRotate(cvnode: cvnode, angle: angle)
            }
            else if cvname.hasPrefix("bridge"){
                bridgeRotate(cvnode: cvnode, angle: angle)
            }
            else if cvname.hasPrefix("qcircle"){
                qcircleRotate(cvnode: cvnode, angle: angle)
            }
            else if cvname.hasPrefix("halftri"){
                triRotate(cvnode: cvnode, angle: angle)
            }
            else if cvname.hasPrefix("cheat"){
                cheatRotate(cvnode: cvnode, angle: angle)
            }
        }
    }

    func shapeFunc_lr1(cvnode:SKNode){
        shapeRotate(cvnode: cvnode, angle: Double.pi/24)
    }
    func shapeFunc_lr2(cvnode:SKNode){
        shapeRotate(cvnode: cvnode, angle: Double.pi/6)
    }
    func shapeFunc_rr1(cvnode:SKNode){
        shapeRotate(cvnode: cvnode, angle: -Double.pi/24)
    }
    func shapeFunc_rr2(cvnode:SKNode){
        shapeRotate(cvnode: cvnode, angle: -Double.pi/6)
    }
    func shapeFunc_cancel(cvnode:SKNode){
        drawnodes[cvnode] = nil
        cvnode.removeFromParent()
        ExitAdjustMode()
    }
    func adjustShapeFromBut(butnode:SKNode){
        if let cvnode = nowcvnode,let butname = butnode.name{
            if butname == KitName.but_up.name{
                shapeFunc_Up(cvnode: cvnode)
            }
            else if butname == KitName.but_down.name{
                shapeFunc_Down(cvnode: cvnode)
            }
            else if butname == KitName.but_left.name{
                shapeFunc_Left(cvnode: cvnode)
            }
            else if butname == KitName.but_right.name{
                shapeFunc_Right(cvnode: cvnode)
            }
            else if butname == KitName.but_lr1.name{
                shapeFunc_lr1(cvnode: cvnode)
            }
            else if butname == KitName.but_lr2.name{
                shapeFunc_lr2(cvnode: cvnode)
            }
            else if butname == KitName.but_rr1.name{
                shapeFunc_rr1(cvnode: cvnode)
            }
            else if butname == KitName.but_rr2.name{
                shapeFunc_rr2(cvnode: cvnode)
            }
            else if butname == KitName.but_cancel.name{
                shapeFunc_cancel(cvnode: cvnode)
            }
        }
        //node.zRotation = node.zRotation + CGFloat(Double.pi)
    }
    func getShapeFromName(place:CGPoint,linewidth:CGFloat,name:String,mode:Int)->SKShapeNode{
        var skshape:SKShapeNode
        if name.hasPrefix("line"){
            skshape = createLine(place:place,length:GameKitPara.linelength,linewidth: linewidth,kind:name,mode:mode)
        }
        else if name.hasPrefix("qcircle"){
            skshape = createQcircle(place: place, linewidth: linewidth, kind: name, mode: mode)
        }
        else if name.hasPrefix("arch"){
            skshape = createArch(place: place, linewidth: linewidth, kind: name, mode: mode)
        }
        else if name.hasPrefix("bridge"){
            skshape = createBridge(place: place, linewidth: linewidth, kind: name, mode: mode)
        }
        else if name.hasPrefix("circle"){
            skshape = createCircle(place: place, linewidth: linewidth, kind: name, mode: mode)
        }
        else if name.hasPrefix("halftri"){
            skshape = createHalfTri(place: place, linewidth: linewidth, kind: name, mode: mode)
        }
        else{
            skshape = SKShapeNode()
        }
        return skshape
    }
}
