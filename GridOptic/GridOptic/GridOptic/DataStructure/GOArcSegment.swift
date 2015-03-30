//
//  GOArcSegment.swift
//  GridOptic
//
//  Created by NULL on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOArcSegment: NSObject {
    var center: GOCoordinate
    var radius: CGFloat
    var radian: CGFloat
    //angle from [0, PI)
    var normalDirection: CGVector
    
    init(center: GOCoordinate, radius: CGFloat, radian: CGFloat, normalDirection: CGVector) {
        self.center = center
        self.radius = radius
        self.radian = radian
        self.normalDirection = normalDirection
    }
    
    var scaledStartVector: CGVector {
        get {
            let startVector = CGVector(
                dx: normalDirection.dx * cos(-radian) - normalDirection.dy * sin(-radian),
                dy: normalDirection.dx * sin(-radian) + normalDirection.dy * cos(-radian)
            )
            return startVector.scaleTo(self.radius)
        }
    }
    
    var scaledEndVector: CGVector {
        let endVector = CGVector(
            dx: normalDirection.dx * cos(radian) - normalDirection.dy * sin(radian),
            dy: normalDirection.dx * sin(radian) + normalDirection.dy * cos(radian)
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
    
    var startRadian: CGFloat {
        get {
            return atan(self.scaledStartVector.dy / self.scaledStartVector.dx)
        }
    }
    
    var endRadian: CGFloat {
        get {
            return atan(self.scaledEndVector.dy / self.scaledEndVector.dx)
        }
    }
}
