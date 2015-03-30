//
//  GOLineSegment.swift
//  GridOptic
//
//  Created by NULL on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOLineSegment: GOSegment {
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
    
    var directionInRadianFromXPlus: CGFloat {
        get {
            return self.direction.angleFromXPlus
        }
    }
    
    var startPoint: CGPoint {
        get {
            let radDirection = self.directionInRadianFromXPlus
            let deltaX = -0.5 * CGFloat(self.length) * sin(radDirection)
            let deltaY = -0.5 * CGFloat(self.length) * cos(radDirection)
            return CGPointMake(CGFloat(center.x) + deltaX, CGFloat(center.y) + deltaY)
        }
    }
    
    var endPoint: CGPoint {
        get {
            let radDirection = self.directionInRadianFromXPlus
            let deltaX = 0.5 * CGFloat(self.length) * sin(radDirection)
            let deltaY = 0.5 * CGFloat(self.length) * cos(radDirection)
            return CGPointMake(CGFloat(center.x) + deltaX, CGFloat(center.y) + deltaY)
        }
    }
    
    override func getIntersactionPoint(ray: GORay) -> CGPoint? {
        return nil;
    }
}
