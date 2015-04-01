//
//  GOConvexLensRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOConvexLensRep: GOOpticRep {
    var thickness: CGFloat = 1
    var curvatureRadius: CGFloat = 5
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
    var inverseNormalDirection: CGVector {
        get {
            return CGVectorMake(-self.normalDirection.dx, -self.normalDirection.dy)
        }
    }
    
    var length: CGFloat {
        get {
            return sqrt(self.curvatureRadius * self.curvatureRadius - (self.curvatureRadius - self.thickness) * (self.curvatureRadius - self.thickness))
        }
    }
    
    init(center: GOCoordinate, direction: CGVector, id: String) {
        self.center = center
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
        let radianSpan = acos((self.curvatureRadius - self.thickness) / self.curvatureRadius)
        
        //left arc
        let centerLeftArc = CGPointMake(CGFloat(self.center.x) + CGFloat(self.thickness)/2 - self.curvatureRadius, CGFloat(self.center.y))
        let leftArc = GOArcSegment(center: centerLeftArc, radius: self.curvatureRadius, radian: radianSpan, normalDirection: self.normalDirection)
        leftArc.tag = 0
        self.edges.append(leftArc)
        
        //right arc
        let centerRightArc = CGPointMake(CGFloat(self.center.x) - CGFloat(self.thickness)/2 + self.curvatureRadius, CGFloat(self.center.y))
        let rightArc = GOArcSegment(center: centerRightArc, radius: self.curvatureRadius, radian: radianSpan, normalDirection: self.inverseNormalDirection)
        rightArc.tag = 1
        self.edges.append(rightArc)
    }
    
    override func setDirection(direction: CGVector) {
        self.direction = direction
        
        for edge in self.edges {
            if edge.tag == 0 {
                var newCenter = edge.center.getPointAfterRotation(about: self.center.point, toAngle: direction.angleFromXPlus)
                edge.normalDirection = self.normalDirection
            } else {
                var newCenter = edge.center.getPointAfterRotation(about: self.center.point, toAngle: direction.angleFromXPlus)
                edge.normalDirection = self.inverseNormalDirection
            }
        }
    }
}
