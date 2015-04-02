//
//  GOConcaveLensRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOConcaveLensRep: GOOpticRep {
    var thicknessCenter: CGFloat = 1
    var thicknessEdge: CGFloat = 2
    var thicknessDifference: CGFloat {
        get {
            return self.thicknessEdge - self.thicknessCenter
        }
    }
    var curvatureRadius: CGFloat = 5
    var center: GOCoordinate
    var direction: CGVector = CGVectorMake(0, 1)
    var normalDirection: CGVector {
        get {
            return CGVectorMake(self.direction.dy, -self.direction.dx)
        }
    }
    var inverseNormalDirection: CGVector {
        get {
            return CGVectorMake(-self.normalDirection.dx, -self.normalDirection.dy)
        }
    }
    
    var length: CGFloat {
        get {
            return 2 * sqrt(self.curvatureRadius * self.curvatureRadius - (self.curvatureRadius - self.thicknessDifference/2) * (self.curvatureRadius - self.thicknessDifference/2))
        }
    }
    
    init(center: GOCoordinate, direction: CGVector, thicknessCenter: CGFloat, thicknessEdge: CGFloat, curvatureRadius: CGFloat, id: String, refractionIndex: CGFloat) {
        self.thicknessCenter = thicknessCenter
        self.thicknessEdge = thicknessEdge
        self.curvatureRadius = curvatureRadius
        self.center = center
        super.init(id: id)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(direction)
    }
    
    init(center: GOCoordinate, direction: CGVector, id: String, refractionIndex: CGFloat) {
        self.center = center
        super.init(id: id)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(direction)
    }
    
    init(center: GOCoordinate, id: String, refractionIndex: CGFloat) {
        self.center = center
        super.init(id: id)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(self.direction)
        self.updateEdgesParent()
    }
    
    private func setUpEdges() {
        let radianSpan = acos((self.curvatureRadius - self.thicknessDifference/2) / self.curvatureRadius) * 2
        
        //top line segment
        let centerTopEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) + CGFloat(self.length)/2)
        let topEdge = GOLineSegment(center: centerTopEdge, length: self.thicknessEdge, direction: self.normalDirection)
        topEdge.tag = 2
        self.edges.append(topEdge)
        
        //right arc
        let centerRightArc = CGPointMake(CGFloat(self.center.x) + CGFloat(self.thicknessCenter)/2 + self.curvatureRadius, CGFloat(self.center.y))
        let rightArc = GOArcSegment(center: centerRightArc, radius: self.curvatureRadius, radian: radianSpan, normalDirection: self.inverseNormalDirection)
        rightArc.tag = 1
        self.edges.append(rightArc)
        
        
        //bottom line segment
        let centerBottomEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) - CGFloat(self.length)/2)
        let bottomEdge = GOLineSegment(center: centerBottomEdge, length: self.thicknessEdge, direction: self.normalDirection)
        bottomEdge.tag = 2
        self.edges.append(bottomEdge)
        
        //left arc
        let centerLeftArc = CGPointMake(CGFloat(self.center.x) - CGFloat(self.thicknessCenter)/2 - self.curvatureRadius, CGFloat(self.center.y))
        let leftArc = GOArcSegment(center: centerLeftArc, radius: self.curvatureRadius, radian: radianSpan, normalDirection: self.normalDirection)
        leftArc.tag = 0
        self.edges.append(leftArc)
    }
    
    override func setDirection(direction: CGVector) {
        let directionDifference = direction.angleFromXPlus - self.direction.angleFromXPlus
        self.direction = direction
        
        for edge in self.edges {
            if edge.tag == 0 {
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.normalDirection = self.normalDirection
            } else if edge.tag == 1 {
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.normalDirection = self.inverseNormalDirection
            } else {
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.direction = self.normalDirection
            }
        }
    }

}
