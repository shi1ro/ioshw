//
//  Calculator.swift
//  Final
//
//  Created by njuios on 2021/1/13.
//

import Foundation
import SpriteKit
extension Double {

    func roundTo(places:Int) -> Double {

        let divisor = pow(10.0, Double(places))

        return (self * divisor).rounded() / divisor

    }

}
extension GameScene{
    func calRotate(point:CGPoint,center:CGPoint,angle:Double)->CGPoint{
        let centerx = Float(center.x)
        let centery = Float(center.y)
        let cosvalue = Float(cos(angle))
        let sinvalue = Float(sin(angle))
        let pointx = Float(point.x)
        let pointy = Float(point.y)
        var newpoint = CGPoint()
 /*       let movematrix1 = matrix_float3x3.init([1,0,centerx], [0,1,centery], [0,0,1])
        let rotatematrix = matrix_float3x3.init([cosvalue,-sinvalue,0], [sinvalue,cosvalue,0], [0,0,1])
        let movematrix2 = matrix_float3x3.init([1,0,-centerx], [0,1,-centery], [0,0,1])
        let finalmatrix = movematrix1 * rotatematrix * movematrix2
        newpoint.x = CGFloat(finalmatrix.columns.0.x * pointx + finalmatrix.columns.0.y * pointy + finalmatrix.columns.0.z)
        newpoint.y = CGFloat(finalmatrix.columns.1.x * pointx + finalmatrix.columns.1.y * pointy + finalmatrix.columns.1.z)*/
        newpoint.x = CGFloat((pointx - centerx)*cosvalue - (pointy - centery)*sinvalue + centerx)
        newpoint.y = CGFloat((pointx - centerx)*sinvalue + (pointy - centery)*cosvalue + centery)
        return newpoint
    }
    func calCenter(points:[CGPoint])->CGPoint{
        if points.count == 0{
            return CGPoint(x: 0, y: 0)
        }
        var cenx = CGFloat(0)
        var ceny = CGFloat(0)
        for point in points{
            cenx = cenx + point.x
            ceny = ceny + point.y
        }
        cenx = cenx / CGFloat(points.count)
        ceny = ceny / CGFloat(points.count)
        return CGPoint(x: cenx, y: ceny)
    }
    func calPointsRotate(points:[CGPoint],center:CGPoint,angle:Double)->[CGPoint]{
        var ropoints = [CGPoint]()
        for point in points{
            let ropoint = calRotate(point: point, center: center, angle: angle)
            ropoints.append(ropoint)
        }
        return ropoints
    }
}
