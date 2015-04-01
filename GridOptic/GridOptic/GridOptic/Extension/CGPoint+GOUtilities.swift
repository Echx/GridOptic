//
//  CGPoint+GOUtilities.swift
//  GridOptic
//
//  Created by NULL on 01/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func getPointAfterRotation(#about: CGPoint, toAngle: CGFloat) -> CGPoint{
        let distance = self.getDistanceToPoint(about)
        let newX = distance * cos(toAngle)
        let newY = distance * sin(toAngle)
        return CGPointMake(about.x + newX, about.y + newY)
    }
    
    func getDistanceToPoint(point: CGPoint) -> CGFloat{
        return sqrt((self.x - point.x) * (self.x - point.x) +
                    (self.y - point.y) * (self.y - point.y))
    }
}