//
//  GOGrid.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

protocol GOGridDelegate {
    
}

class GOGrid: NSObject {
    var unitLength: CGFloat
    var width: NSInteger
    var height: NSInteger
    var origin: CGPoint = CGPointZero
    var instruments = [GOOpticRep]()
    var delegate: GOGridDelegate?
    var size: CGSize {
        get {
            return CGSizeMake(CGFloat(self.width) * self.unitLength, CGFloat(self.height) * self.unitLength)
        }
    }
    
    init(width: NSInteger, height: NSInteger, andUnitLength unitLength: CGFloat) {
        self.width = width
        self.height = height
        self.unitLength = unitLength
        super.init()
    }
    
    init(coordinate: GOCoordinate, andUnitLength unitLength: CGFloat) {
        self.width = coordinate.x
        self.height = coordinate.y
        self.unitLength = unitLength
        super.init()
    }
    
    func getCenterForGridCell(coordinate: GOCoordinate) -> CGPoint {
        return CGPointMake(origin.x + CGFloat(coordinate.x) * self.unitLength,
                           origin.y + CGFloat(coordinate.y) * self.unitLength)
    }
    
    func getGridCoordinateForPoint(point: CGPoint) {
        var x = round(point.x / self.unitLength - 0.5)
        var y = round(point.y / self.unitLength - 0.5)
    }

    //given a ray to start, this method will return every critical point of the path (i.e. the contact points between light paths and instruments)
    func getRayPathCriticalPoints(ray: GORay) -> [CGPoint] {
        let criticalPoints = [CGPoint]()
        
        //TODO
        
        return criticalPoints
    }
    
    //given a ray and an edge, get the reflect/refract outcome, nil if there is no reflect/refract outcome
    func getOutcomeRay(ray: GORay, edge: GOSegment) -> GORay? {
        
        //TODO
        
        return nil
    }
    
    //given a ray to start, return nearest edge on the ray's path, nil if no edge lies on the path
    func getNearestEdgeOnDirection(ray: GORay) -> GOSegment? {
        
        //TODO
        
        return nil
    }
    
    //given a ray to start, return all edges on the rays path
    func getEdgesOnDirection(ray: GORay) -> [GOSegment] {
        let edges = [GOSegment]()
        
        //TODO
        
        return edges
    }
}
