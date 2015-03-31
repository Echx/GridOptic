//
//  GORay.swift
//  GridOptic
//
//  Created by NULL on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GORay: NSObject {
    var startPoint: CGPoint
    var direction: CGVector
    
    init(startPoint: CGPoint, direction: CGVector) {
        self.startPoint = startPoint;
        self.direction = direction
    }
    
    //give the corresponding y of a given x, nil if not defined
    func getY(#x: CGFloat) -> CGFloat? {
        if self.direction.dx > 0 && x < self.startPoint.x {
            return nil
        }
        
        if self.direction.dx < 0 && x > self.startPoint.x {
            return nil
        }
        
        let deltaX = x - self.startPoint.x
        let deltaY = deltaX * self.direction.dy / self.direction.dx
        return self.startPoint.y + deltaY
    }

    //give the corresponding x of a given y, nil if not defined
    func getX(#y: CGFloat) -> CGFloat? {
        if self.direction.dy > 0 && y < self.startPoint.y {
            return nil
        }
        
        if self.direction.dy < 0 && y > self.startPoint.y {
            return nil
        }
        
        let deltaY = y - self.startPoint.y
        let deltaX = deltaY * self.direction.dx / self.direction.dy
        return self.startPoint.x + deltaX
    }
}
