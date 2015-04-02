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
    var instruments = [String: GOOpticRep]()
    var delegate: GOGridDelegate?
    var size: CGSize {
        get {
            return CGSizeMake(CGFloat(self.width) * self.unitLength, CGFloat(self.height) * self.unitLength)
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
    
    func getCenterForGridCell(coordinate: GOCoordinate) -> CGPoint {
        return CGPointMake(origin.x + CGFloat(coordinate.x) * self.unitLength,
                           origin.y + CGFloat(coordinate.y) * self.unitLength)
    }
    
    func getGridCoordinateForPoint(point: CGPoint) {
        var x = round(point.x / self.unitLength)
        var y = round(point.y / self.unitLength)
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
        // first try get the nearest edge
        if let nearestEdge = self.getNearestEdgeOnDirection(ray) {
            // TODO: define indexIn and indexOut
            return nearestEdge.getOutcomeRay(rayIn: ray, indexIn: 1.0, indexOut: 1.0)
        } else {
            return nil
        }
    }
    
    //given a ray to start, return nearest edge on the ray's path, nil if no edge lies on the path
    func getNearestEdgeOnDirection(ray: GORay) -> GOSegment? {
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
                return point
            }
        }
        
        return nil
    }
    
}
