//
//  GOUtilities.swift
//  GridOptic
//
//  Created by Lei Mingyu on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

extension CGVector {
    var length: CGFloat {
        get {
            return sqrt(self.dx * self.dx + self.dy * self.dy)
        }
    }
    
    func scaleTo(length: CGFloat) -> CGVector {
        let currentLength = self.length
        let newDx = self.dx * length / self.length
        let newDy = self.dx * length / self.length
        return CGVector(dx: newDx, dy: newDy)
    }
    
    //give result in [0, 2PI)
    var angleFromXPlus: CGFloat {
        get {
            var rawAngle = CGFloat(atan(self.dy / self.dx))
            
            if self.dx > 0 && self.dy > 0 {
                return rawAngle
            } else if self.dx < 0 && self.dy > 0 {
                return CGFloat(M_PI) + rawAngle
            } else if self.dx < 0 && self.dy < 0 {
                return CGFloat(M_PI) + rawAngle
            } else if self.dx > 0 && self.dy < 0 {
                return CGFloat(2 * M_PI) + rawAngle
            } else if self.dx == 0 && self.dy < 0 {
                return CGFloat(M_PI * 3 / 2)
            } else if self.dx == 0 && self.dy > 0 {
                return CGFloat(M_PI/2)
            } else if self.dy == 0 && self.dx < 0 {
                return CGFloat(M_PI)
            } else if self.dy == 0 && self.dx > 0 {
                return CGFloat(0)
            } else {
                fatalError("undefined angle")
            }
        }
    }
    

    static func vectorFromXPlusRadius(radius: CGFloat) -> CGVector{
        return CGVectorMake(cos(radius), sin(radius))
    }
}

