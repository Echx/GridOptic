//
//  GO2DRepresentation.swift
//  GridOptic
//
//  Created by NULL on 30/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class GOSegment {
    
    func getRayAfterIntersaction(ray: GORay) -> GORay? {
        return nil;
    }
    
    func getIntersactionPoint(ray: GORay) -> CGPoint? {
        if let newRay = self.getRayAfterIntersaction(ray) {
            return newRay.startPoint
        } else {
            return nil
        }
    }
    
    func isIntersacedWithRay(ray: GORay) -> Bool {
        return self.getIntersactionPoint(ray) == nil
    }
}
