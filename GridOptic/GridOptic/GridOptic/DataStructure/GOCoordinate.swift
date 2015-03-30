//
//  GOCoordinate.swift
//  GridOptic
//
//  Created by NULL on 30/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class GOCoordinate: NSObject {
    let x: NSInteger
    let y: NSInteger
    
    private init(x: NSInteger, y: NSInteger) {
        self.x = x
        self.y = y
    }
    
    class func GOCoordinateMake(x: NSInteger, y: NSInteger) -> GOCoordinate {
        return GOCoordinate(x: x, y: y)
    }
}
