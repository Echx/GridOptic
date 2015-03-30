//
//  GOLineSegment.swift
//  GridOptic
//
//  Created by NULL on 30/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class GOLineSegment: NSObject {
    var center: GOCoordinate
    var length: NSInteger
    
    //angle should be within [0, PI) from
    var direction: CGVector
    
    
    init(center: GOCoordinate, length: NSInteger, direction: CGVector) {
        self.center = center;
        self.length = length;
        if direction.dy <= 0 {
            self.direction = CGVectorMake(-direction.dx, -direction.dy)
        } else  {
            self.direction = direction
        }
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
}
