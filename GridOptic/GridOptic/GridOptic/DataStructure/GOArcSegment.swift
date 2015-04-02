//
//  GOArcSegment.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOArcSegment: GOSegment {
    var radius: CGFloat
    var radian: CGFloat
    
    override var bezierPath: UIBezierPath {
        get {
//            println("\n\n\n\n")
//            println("start:         \(self.startPoint)")
//            println("end:           \(self.startPoint)")
//            println("center:        \(self.center)")
//            println("radius:        \(self.radius)")
//            println("radian:        \(self.radian)")
//            println("startA:        \(self.startRadian)")
//            println("endA:          \(self.endRadian)")
//            println("direction:     \(self.direction)")
//            println("directionA:    \(self.direction.angleFromXPlus)")
            var path = UIBezierPath()
            path.addArcWithCenter(self.center, radius: self.radius, startAngle: self.endRadian, endAngle: self.startRadian, clockwise: false)
            return path
        }
    }
    
    init(center: CGPoint, radius: CGFloat, radian: CGFloat, normalDirection: CGVector) {
        self.radius = radius
        self.radian = radian
        super.init()
        self.normalDirection = normalDirection
        self.center = center
    }
    
    var scaledStartVector: CGVector {
        get {
            let startVector = CGVector(
                dx: normalDirection.dx * cos(-radian / 2) - normalDirection.dy * sin(-radian / 2),
                dy: normalDirection.dx * sin(-radian / 2) + normalDirection.dy * cos(-radian / 2)
            )
            return startVector.scaleTo(self.radius)
        }
    }
    
    var scaledEndVector: CGVector {
        let endVector = CGVector(
            dx: normalDirection.dx * cos(radian / 2) - normalDirection.dy * sin(radian / 2),
            dy: normalDirection.dx * sin(radian / 2) + normalDirection.dy * cos(radian / 2)
        )
        return endVector.scaleTo(self.radius)
    }
    
    var startPoint: CGPoint {
        get {
            return CGPoint(
                x: CGFloat(center.x) + self.scaledStartVector.dx,
                y: CGFloat(center.y) + self.scaledStartVector.dy
            )
        }
    }
    
    var endPoint: CGPoint {
        get {
            return CGPoint(
                x: CGFloat(center.x) + self.scaledEndVector.dx,
                y: CGFloat(center.y) + self.scaledEndVector.dy
            )
        }
    }
    
    // radian will be [0, 2*Pi)
    
    var startRadian: CGFloat {
        get {
            var result = self.normalDirection.angleFromXPlus - self.radian / 2
            return result.restrictWithin2Pi
        }
    }
    
    var endRadian: CGFloat {
        get {
            var result = self.normalDirection.angleFromXPlus + self.radian / 2
            return result.restrictWithin2Pi
        }
    }
    
    
    override func getIntersectionPoint(ray: GORay) -> CGPoint? {
        let lineOfRay = ray.line
        let k = lineOfRay.slope
        let c = lineOfRay.yIntercept
        let r1 = CGFloat(self.center.x)
        let r2 = CGFloat(self.center.y)
        let r = self.radius
        let termA = 1 + k * k
        let termB = 2 * ((c - r2) * k - r1)
        let termC = r1 * r1 + (r2 - c) * (r2 - c) - r * r
        
        let xs = GOUtilities.solveQuadraticEquation(termA, b: termB, c: termC)
        
        if xs.0 == nil {
            return nil
        } else if xs.1 == nil {
            // 相切
            if let y = ray.getY(x: xs.0!) {
                let point = CGPoint(x: xs.0!, y: y)
                if self.containsPoint(point) {
                    if point.isNearEnough(ray.startPoint) {
                        println("intersection is ray startPoint")
                        return nil
                    } else {
                        return point
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            if let y0 = ray.getY(x: xs.0!) {
                if let y1 = ray.getY(x: xs.1!) {
                    if GOUtilities.getDistanceBetweenPoints(ray.startPoint, b: CGPoint(x: xs.0!, y: y0)) >
                        GOUtilities.getDistanceBetweenPoints(ray.startPoint, b: CGPoint(x: xs.1!, y: y1)) {
                        let point = CGPoint(x: xs.1!, y: y1)
                        if self.containsPoint(point) {
                            if point.isNearEnough(ray.startPoint) {
                                println("intersection is ray startPoint")
                                return nil
                            } else {
                                return point
                            }
                        }
                    }
                    let point = CGPoint(x: xs.0!, y: y0)
                    if self.containsPoint(point) {
                        if point.isNearEnough(ray.startPoint) {
                            println("intersection is ray startPoint")
                            return nil
                        } else {
                            return point
                        }
                    } else {
                        return nil
                    }
                } else {
                    let point = CGPoint(x: xs.0!, y: y0)
                    if self.containsPoint(point) {
                        if point.isNearEnough(ray.startPoint) {
                            println("intersection is ray startPoint")
                            return nil
                        } else {
                            return point
                        }
                    } else {
                        return nil
                    }
                }
            } else {
                if let y1 = ray.getY(x: xs.1!) {
                    let point = CGPoint(x: xs.1!, y: y1)
                    if self.containsPoint(point) {
                        if point.isNearEnough(ray.startPoint) {
                            println("intersection is ray startPoint")
                            return nil
                        } else {
                            return point
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
        }
    }
    
    override func getRefractionRay(#rayIn: GORay, indexIn: CGFloat, indexOut: CGFloat) -> GORay? {
        if let intersectionPoint = self.getIntersectionPoint(rayIn) {
            let l = rayIn.direction.normalised
            let tangentNormal = CGVector(dx: intersectionPoint.x - self.center.x,
                dy: intersectionPoint.y - self.center.y)
            let deg = M_PI / 2
            var n: CGVector
            
            if CGVector.dot(rayIn.direction, v2: tangentNormal) < 0 {
                n = tangentNormal.normalised
            } else {
                n = CGVectorMake(-tangentNormal.dx, -tangentNormal.dy).normalised
            }
            
            let cosTheta1 = CGVector.dot(n, v2: l)
            let cosTheta2 = sqrt(1 - (indexIn / indexOut) * (indexIn / indexOut) * (1 - cosTheta1 * cosTheta1))
            
            let x = (indexIn / indexOut) * l.dx + (indexIn / indexOut * cosTheta1 - cosTheta2) * n.dx
            let y = (indexIn / indexOut) * l.dy + (indexIn / indexOut * cosTheta1 - cosTheta2) * n.dy
            
            return GORay(startPoint: intersectionPoint, direction: CGVectorMake(x, y))
        } else {
            return nil
        }
    }
    
    override func getReflectionRay(#rayIn: GORay) -> GORay? {
        if let intersectionPoint = self.getIntersectionPoint(rayIn) {
            let l = rayIn.direction.normalised
            let tangentNormal = CGVector(dx: intersectionPoint.x - self.center.x,
                dy: intersectionPoint.y - self.center.y)
            let deg = M_PI / 2
            let tangent = tangentNormal.rotate(CGFloat(deg))
            
            // calculate the ray
            let tangentAngle = tangent.angleFromXPlus
            let reflectionAngle = 2 * tangentAngle + CGFloat(2 * M_PI) - rayIn.direction.angleFromXPlus
            var reflectDirection = GOUtilities.vectorFromRadius(reflectionAngle)
            
            return GORay(startPoint: intersectionPoint, direction: reflectDirection)
        } else {
            return nil
        }
    }

    
    func containsPoint(point: CGPoint) -> Bool {
        if ((point.getDistanceToPoint(self.center) - self.radius).abs <= CGFloat(0.0001)) {
            let pointRadian = point.getRadiusFrom(self.center).restrictWithin2Pi
            let normalRadian = self.normalDirection.angleFromXPlus
            let maxRadian = max(self.startRadian, self.endRadian)
            let minRadian = min(self.startRadian, self.endRadian)
        
            if normalRadian > maxRadian || normalRadian < minRadian {
                return pointRadian > maxRadian || pointRadian < minRadian
            } else {
                return pointRadian <= maxRadian && pointRadian >= minRadian
            }
        } else {
            return false
        }
    }
    
}
