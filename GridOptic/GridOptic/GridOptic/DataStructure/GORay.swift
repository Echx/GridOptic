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
}
