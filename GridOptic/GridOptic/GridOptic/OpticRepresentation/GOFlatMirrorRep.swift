//
//  GOFlatMirrorRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOFlatMirrorRep: GOOpticRep {
    var thickness: NSInteger
    var length: NSInteger
    var center: GOCoordinate
    var direction: CGVector = CGVectorMake(0, 1)
    var normalDirection: CGVector {
        get {
            if self.direction.dx > 0 {
                return CGVectorMake(-self.direction.dy, self.direction.dx)
            } else if self.direction.dx == 0 && self.direction.dy < 0 {
                return CGVectorMake(-self.direction.dy, 0)
            } else {
                return CGVectorMake(self.direction.dy, -self.direction.dx)
            }
        }
    }
    
    
    init(center: GOCoordinate, thickness: NSInteger, length: NSInteger, direction: CGVector) {
        self.center = center
        self.thickness = thickness
        self.length = length
        super.init()
        self.setUpEdges()
        self.setDirection(direction)
    }
    
    private func setUpEdges() {
        //left edge
        let centerLeftEdge = CGPointMake(CGFloat(self.center.x) - CGFloat(self.thickness)/2, CGFloat(self.center.y))
        let leftEdge = GOLineSegment(center: centerLeftEdge, length: self.length, direction: self.direction)
        leftEdge.tag = 0
        self.edges.append(leftEdge)
        
        //right edge
        let centerRightEdge = CGPointMake(CGFloat(self.center.x) + CGFloat(self.thickness)/2, CGFloat(self.center.y))
        let rightEdge = GOLineSegment(center: centerRightEdge, length: self.length, direction: self.direction)
        leftEdge.tag = 0
        self.edges.append(rightEdge)
        
        //top edge
        let centerTopEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) + CGFloat(self.length)/2)
        let topEdge = GOLineSegment(center: centerTopEdge, length: self.thickness, direction: self.normalDirection)
        leftEdge.tag = 1
        self.edges.append(topEdge)
        
        //bottom edge
        let centerBottomEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) - CGFloat(self.length)/2)
        let bottomEdge = GOLineSegment(center: centerBottomEdge, length: self.thickness, direction: self.normalDirection)
        leftEdge.tag = 1
        self.edges.append(bottomEdge)
    }

    func setDirection(direction: CGVector) {
        self.direction = direction
        
        for edge in self.edges {
            if edge.tag == 0 {
                var newCenter = edge.center.getPointAfterRotation(about: self.center.point, toAngle: direction.angleFromXPlus)
                edge.direction = self.direction
            } else {
                var newCenter = edge.center.getPointAfterRotation(about: self.center.point, toAngle: direction.angleFromXPlus)
                edge.direction = self.normalDirection
            }
        }
    }
}
