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
    var normal: CGVector
    
    init(center: GOCoordinate, radius: CGFloat, radian: CGFloat, normal: CGVector) {
        self.center = center
        self.radius = radius
        self.radian = radian
        self.normal = normal
    }
    
    var startPoint: CGPoint {
        get {
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
