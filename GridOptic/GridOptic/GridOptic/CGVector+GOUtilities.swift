//
//  GOUtilities.swift
//  GridOptic
//
//  Created by Lei Mingyu on 30/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

extension CGVector {
    var placeholder {
        
    }
    
    //give result in [-PI, PI)
    var angleFromXPlus: CGFloat {
        get {
            var rawAngle = CGFloat(atan(self.dy / self.dx))
            
            if self.dx > 0 && self.dy > 0 {
                return rawAngle
            } else if self.dx < 0 && self.dy > 0 {
                return CGFloat(M_PI) + rawAngle
            } else if self.dx < 0 && self.dy < 0 {
                return CGFloat(-M_PI) + rawAngle
            } else if self.dx > 0 && self.dy < 0 {
                return rawAngle
            } else if self.dx == 0 && self.dy < 0 {
                return CGFloat(-M_PI/2)
            } else if self.dx == 0 && self.dy > 0 {
                return CGFloat(M_PI/2)
            } else if self.dy == 0 && self.dx < 0 {
                return CGFloat(-M_PI)
            } else if self.dy == 0 && self.dx > 0 {
                return CGFloat(0)
            } else {
                fatalError("undefined angle")
            }
        }
    }
}

