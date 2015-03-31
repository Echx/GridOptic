//
//  GO2DRepresentation.swift
//  GridOptic
//
//  Created by NULL on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOSegment {
    
    func getIntersectionPoint(ray: GORay) -> CGPoint? {
        return nil;
    }
    
    func isIntersacedWithRay(ray: GORay) -> Bool {
        return self.getIntersectionPoint(ray) == nil
    }
}
