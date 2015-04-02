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
    let unitLength: CGFloat
    let width: NSInteger
    let height: NSInteger
    let origin: CGPoint = CGPointZero
    let backgroundRefractionIndex: CGPoint = 1.0
    
    var instruments = [String: GOOpticRep]()
    var delegate: GOGridDelegate?
    var refractionEdgeParentStack = GOStack<String>()
    
    var size: CGSize {
        get {
            return CGSizeMake(CGFloat(self.width) * self.unitLength, CGFloat(self.height) * self.unitLength)
        }
    }
    
    var transformToDisplay: CGAffineTransform {
        get {
            return CGAffineTransformMakeScale(self.unitLength, self.unitLength)
        }
    }
    
    var transformToGrid: CGAffineTransform {
        get {
            return CGAffineTransformMakeScale(1/self.unitLength, 1/self.unitLength)
        }
    }
    
    var boundaries : [GOSegment] {
        get {
            var boundaries = [GOLineSegment]()
            
            let bottomBound = GOLineSegment(center: CGPoint(x: origin.x + CGFloat(width / 2),
                y: origin.y), length: CGFloat(width), direction: CGVector(dx: 1, dy: 0))
            let upperBound = GOLineSegment(center: CGPoint(x: origin.x + CGFloat(width / 2),
                y: origin.y + CGFloat(height)), length: CGFloat(width), direction: CGVector(dx: 1, dy: 0))
            let leftBound = GOLineSegment(center: CGPoint(x: origin.x,
                y: origin.y + CGFloat(height / 2)), length: CGFloat(height), direction: CGVector(dx: 0, dy: 1))
            let rightBound = GOLineSegment(center: CGPoint(x: origin.x + CGFloat(width),
                y: origin.y + CGFloat(height / 2)), length: CGFloat(height), direction: CGVector(dx: 0, dy: 1))
            
            boundaries.append(bottomBound)
            boundaries.append(upperBound)
            boundaries.append(leftBound)
            boundaries.append(rightBound)

            return boundaries
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
    
    func addInstrument(instrument: GOOpticRep) -> Bool{
        if self.instruments[instrument.id] == nil {
            self.instruments[instrument.id] = instrument
            return true
        } else {
            return false
        }
    }
    
    func getInstrumentDisplayPathForID(id: String) -> UIBezierPath? {
        if let instrument = self.getInstrumentForID(id) {
            let bezierPath = instrument.bezierPath.copy() as UIBezierPath
            bezierPath.applyTransform(self.transformToDisplay)
            return bezierPath
        } else {
            return nil
        }
    }
    
    func getRefractionIndexForID(id: String) -> CGFloat? {
        return self.instruments[id]?.refractionIndex
    }
    
    func getInstrumentForID(id: String) -> GOOpticRep? {
        return self.instruments[id]
    }
    
    func getCenterForGridCell(coordinate: GOCoordinate) -> CGPoint {
        return CGPointMake(origin.x + CGFloat(coordinate.x) * self.unitLength,
                           origin.y + CGFloat(coordinate.y) * self.unitLength)
    }
    
    func getGridCoordinateForPoint(point: CGPoint) {
        var x = round(point.x / self.unitLength)
        var y = round(point.y / self.unitLength)
    }
    
    func getDisplayPointForGridPoint(point: CGPoint) -> CGPoint {
        return CGPointApplyAffineTransform(point, self.transformToDisplay)
    }
    
    func getGridPointForDisplayPoint(point: CGPoint) -> CGPoint {
        return CGPointApplyAffineTransform(point, self.transformToGrid)
    }
    
    //the ray is in the grid coordinate system
    func getRayPath(ray: GORay) -> UIBezierPath {
        var path = UIBezierPath()
        path.moveToPoint(ray.startPoint)
        let criticalPoints = self.getRayPathCriticalPoints(ray)
        
        for point in criticalPoints {
            path.addLineToPoint(point)
            println(point)
        }
        path.applyTransform(self.transformToDisplay)
        return path
    }

    //given a ray to start, this method will return every critical point of the path (i.e. the contact points between light paths and instruments)
    func getRayPathCriticalPoints(ray: GORay) -> [CGPoint] {
        var criticalPoints = [CGPoint]()
        
        // first add the start point of the ray
        criticalPoints.append(ray.startPoint)
        
        // from the given ray, we found out each nearest edge
        // loop through each resulted ray until we get nil result (no intersection anymore)
        var edge = getNearestEdgeOnDirection(ray)
        var currentRay : GORay = ray
        // mark if the final ray will end at the boundary
        var willEndAtBoundary = true
        while (edge != nil) {
            // it must hit the edge, add the intersection point
            criticalPoints.append(edge!.getIntersectionPoint(currentRay)!)
            
            if let outcomeRay = getOutcomeRay(currentRay, edge: edge!) {
                edge = getNearestEdgeOnDirection(outcomeRay)
                currentRay = outcomeRay
            } else {
                // no outcome ray, hit wall or planck
                willEndAtBoundary = false
                break
            }
        }
        
        if willEndAtBoundary {
            // found out the intersection with the boundary
            // we treat boundary as 4 line segments
            criticalPoints.append(getIntersectionWithBoundary(ray: currentRay)!)
        }
        return criticalPoints
    }
    
    //given a ray and an edge, get the reflect/refract outcome, nil if there is no reflect/refract outcome
    func getOutcomeRay(ray: GORay, edge: GOSegment) -> GORay? {
        var indexIn: CGFloat
        var indexOut: CGFloat
        if edge.willRefract {
            if self.refractionEdgeParentStack.peek() == edge.parent {
                indexIn = self.getRefractionIndexForID(self.refractionEdgeParentStack.pop())!
                if let nextInstrument = self.refractionEdgeParentStack.peek() {
                    indexOut = self.getRefractionIndexForID(nextInstrument)!
                } else {
                    indexOut = self.backgroundRefractionIndex
                }
            } else {
                if let previousInstrument = self.refractionEdgeParentStack.peek() {
                    indexIn = self.getRefractionIndexForID(previousInstrument)!
                } else {
                    indexIn = self.backgroundRefractionIndex
                }
                indexOut = self.getRefractionIndexForID(edge.parent)
                self.refractionEdgeParentStack.push(edge.parent)
            }
        }
        
        return edge.getOutcomeRay(rayIn: ray, indexIn: indexIn, indexOut: indexOut)
    }
    
    //given a ray to start, return nearest edge on the ray's path, nil if no edge lies on the path
    func getNearestEdgeOnDirection(ray: GORay) -> GOSegment? {
        println("getNearestEdgesOnDirection")
        // first retrieve back the edges on ray's path(if any)
        var edges = self.getEdgesOnDirection(ray)
        
        // if no edge on the ray path, return nil
        if edges.isEmpty {
           return nil
        }
        
        // get each intersection point with the edge
        // calculate its distance with the origin of the ray
        // find out the minimum one and return
        var minEdge = edges.first!
        var minDistance : CGFloat = CGFloat.max
        for edge in edges {
            var intersectPoint = edge.getIntersectionPoint(ray)!
            let distance = ray.startPoint.getDistanceToPoint(intersectPoint)
            // if current point is nearer, set the result edge be it
            if distance < minDistance {
                minEdge = edge
            }
        }
        
        return minEdge
    }
    
    //given a ray to start, return all edges on the rays path
    func getEdgesOnDirection(ray: GORay) -> [GOSegment] {
        println("getEdgesOnDirection")
        var edges = [GOSegment]()
        
        for (name, item) in self.instruments {
            // iterate through each instrument, and check if the ray is
            // intersect with the edges of the instruments
            let currentEdges = item.edges
            for edge in currentEdges {
                // check if this edge is intersected with the ray
                if edge.isIntersectedWithRay(ray) {
                    edges.append(edge)
                }
            }
        }
        
        return edges
    }
    
    func getAllEdges() -> [GOSegment]? {
        println("getAllEdges")
        // firstly add all boundaries
        var output = self.boundaries
        
        // if it has instruments, add it to edge
        if (!self.instruments.isEmpty) {
            for (name, item) in self.instruments {
                let currentEdges = item.edges
                for edge in currentEdges {
                        output.append(edge)
                }
            }
        }
        
        return output
    }
    
    private func getIntersectionWithBoundary(#ray:GORay) -> CGPoint? {
        for bound in boundaries {
            if let point = bound.getIntersectionPoint(ray) {
                println(point)
                return point
            }
        }
        
        return nil
    }
    
}
