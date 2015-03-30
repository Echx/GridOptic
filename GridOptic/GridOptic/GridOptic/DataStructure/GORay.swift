//
//  GORay.swift
//  GridOptic
//
//  Created by NULL on 30/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class GORay: NSObject {
    var startPoint: GOCoordinate
    var direction: CGVector
    
    
    init(startPoint: GOCoordinate, direction: CGVector) {
        self.startPoint = startPoint;
        self.direction = direction
    }
}
