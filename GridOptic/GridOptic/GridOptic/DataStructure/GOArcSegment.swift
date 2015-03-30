//
//  GOArcSegment.swift
//  GridOptic
//
//  Created by NULL on 30/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
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
    
    var startPoint: CGPoint {
        get {
            let startVector = CGVector(
                dx: normalDirection.dx * cos(-radian) - normalDirection.dy * sin(-radian),
                dy: normalDirection.dx * sin(radian) + normalDirection.dy * cos(radian)
            )
            return CGPointZero
        }
    }
    
    var endPoint: CGPoint {
        get {
            return CGPointZero
        }
    }
    
    var startRadian: CGFloat {
        get {
            return 0.0
        }
    }
    
    var endRadian: CGFloat {
        get {
            return 0.0
        }
    }
}
