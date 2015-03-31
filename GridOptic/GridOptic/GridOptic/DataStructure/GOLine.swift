//
//  GOLine.swift
//  GridOptic
//
//  Created by NULL on 31/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class GOLine: NSObject {
    var anyPoint: CGPoint
    var direction: CGVector
    
    init(anyPoint: CGPoint, direction: CGVector) {
        self.anyPoint = anyPoint;
        self.direction = direction
    }
    
    //give the corresponding y of a given x, nil if not defined
    func getY(#x: CGFloat) -> CGFloat? {
        let deltaX = x - self.anyPoint.x
        let deltaY = deltaX * self.direction.dy / self.direction.dx
        return self.anyPoint.y + deltaY
    }
    
    //give the corresponding x of a given y, nil if not defined
    func getX(#y: CGFloat) -> CGFloat? {
        let deltaY = y - self.anyPoint.y
        let deltaX = deltaY * self.direction.dx / self.direction.dy
        return self.anyPoint.x + deltaX
    }
}
