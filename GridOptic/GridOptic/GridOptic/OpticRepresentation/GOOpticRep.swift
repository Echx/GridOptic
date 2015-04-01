//
//  GOOpticRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOOpticRep: NSObject {
    var edges = [GOSegment]()
    var type = DeviceType.Mirror
    
    var numOfEdges : Int {
        get {
            return edges.count
        }
    }
    
    var refractionIndex : CGFloat = 1.0
    
    func setDeviceType(type: DeviceType) {
        self.type = type
        self.updateEdgesType()
    }
    
    private func updateEdgesType() {
        for edge in self.edges {
            switch self.type {
            case DeviceType.Mirror:
                edge.willReflect = true
                edge.willRefract = false
            case DeviceType.Lens:
                edge.willReflect = false
                edge.willRefract = true
            case DeviceType.Wall:
                edge.willReflect = false
                edge.willRefract = false
            default:
                fatalError("Device Type Not Defined")
            }
        }
    }
}
