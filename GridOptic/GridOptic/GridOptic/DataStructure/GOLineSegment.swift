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
    
    var line: GOLine {
        get {
            return GOLine(anyPoint: CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y)), direction: self.direction)
        }
    }
    
    init(center: GOCoordinate, length: NSInteger, direction: CGVector) {
        self.center = center;
        self.length = length;
        if direction.dy < 0 {
            self.direction = CGVectorMake(-direction.dx, -direction.dy)
        } else if direction.dy == 0 {
            if direction.dx < 0 {
                self.direction = CGVectorMake(-direction.dx, direction.dy)
            } else {
                self.direction = direction
            }
        } else {
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
            let deltaX = -0.5 * CGFloat(self.length) * cos(radDirection)
            let deltaY = -0.5 * CGFloat(self.length) * sin(radDirection)
            return CGPointMake(CGFloat(center.x) + deltaX, CGFloat(center.y) + deltaY)
        }
    }
    
    var endPoint: CGPoint {
        get {
            let radDirection = self.directionInRadianFromXPlus
            let deltaX = 0.5 * CGFloat(self.length) * cos(radDirection)
            let deltaY = 0.5 * CGFloat(self.length) * sin(radDirection)
            return CGPointMake(CGFloat(center.x) + deltaX, CGFloat(center.y) + deltaY)
        }
    }
    
    override func getIntersactionPoint(ray: GORay) -> CGPoint? {
        if let lineIntersaction = GOLine.getIntersaction(line1: self.line, line2: ray.line) {
            let start = self.startPoint
            let end = self.endPoint
            
            //get the left and right most x of this line segment
            let leftX = start.x < end.x ? start.x : end.x
            let rightX = start.x < end.x ? end.x : start.x
            
            //if the intersaction point is not within [leftX, rightX], then there is no intersaction point
            if lineIntersaction.x < leftX || lineIntersaction.x > rightX {
                return nil
            } else {
                return lineIntersaction
            }
        }
        return nil
    }
    
    func getRefelctionRay(ray: GORay) -> GORay? {
        if self.isIntersacedWithRay(ray) {
            // get intersaction point
            let intersectionPoint = self.getIntersactionPoint(ray)!
            // calculate the ray
            let mirrorAngle = self.directionInRadianFromXPlus
            let reflectionAngle = 2 * mirrorAngle + CGFloat(2 * M_PI) - ray.direction.angleFromXPlus
            var reflectDirection = GOUtilities.vectorFromRadius(reflectionAngle)

            return GORay(startPoint: intersectionPoint, direction: reflectDirection)
        } else {
            return nil
        }
    }
    
}
