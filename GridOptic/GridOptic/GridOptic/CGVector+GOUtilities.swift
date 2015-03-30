//
//  GOUtilities.swift
//  GridOptic
//
//  Created by Lei Mingyu on 30/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
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
}

