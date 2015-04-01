//
//  GOCoordinate.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOCoordinate: NSObject {
    let x: NSInteger
    let y: NSInteger
    
    init(x: NSInteger, y: NSInteger) {
        self.x = x
        self.y = y
    }
    
    class func GOCoordinateMake(x: NSInteger, y: NSInteger) -> GOCoordinate {
        return GOCoordinate(x: x, y: y)
    }
}
