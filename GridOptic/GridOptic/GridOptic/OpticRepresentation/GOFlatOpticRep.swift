//
//  GOFlatOpticRep.swift
//  GridOptic
//
//  Created by NULL on 01/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class GOFlatOpticRep: GOOpticRep {
    var thickness: CGFloat = 1
    var length: CGFloat = 6
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
    
    
    init(center: GOCoordinate, thickness: CGFloat, length: CGFloat, direction: CGVector, refractionIndex: CGFloat, id: String) {
        self.center = center
        self.thickness = thickness
        self.length = length
        super.init(refractionIndex: refractionIndex, id: id)
        self.setUpEdges()
        self.setDirection(direction)
    }
    
    
    init(center: GOCoordinate, thickness: CGFloat, length: CGFloat, direction: CGVector, id: String) {
        self.center = center
        self.thickness = thickness
        self.length = length
        super.init(id: id)
        self.setUpEdges()
        self.setDirection(direction)
    }
    
    init(center: GOCoordinate, id: String) {
        self.center = center
        super.init(id: id)
        self.setUpEdges()
        self.setDirection(self.direction)
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
        rightEdge.tag = 0
        self.edges.append(rightEdge)
        
        //top edge
        let centerTopEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) + CGFloat(self.length)/2)
        let topEdge = GOLineSegment(center: centerTopEdge, length: self.thickness, direction: self.normalDirection)
        topEdge.tag = 1
        self.edges.append(topEdge)
        
        //bottom edge
        let centerBottomEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) - CGFloat(self.length)/2)
        let bottomEdge = GOLineSegment(center: centerBottomEdge, length: self.thickness, direction: self.normalDirection)
        bottomEdge.tag = 1
        self.edges.append(bottomEdge)
    }
    
    override func setDirection(direction: CGVector) {
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
