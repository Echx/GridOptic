//
//  GOLineSegmentTest.swift
//  GridOptic
//
//  Created by NULL on 31/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit
import XCTest

class GOLineSegmentTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLineSegment() {
        var lineSegment = GOLineSegment(center: GOCoordinate(x: 4, y: 4), length: 4, direction: CGVectorMake(1, -2))
        var rayOut = lineSegment.getRefractionVector(
            rayIn: GORay(startPoint: CGPointMake(0, 0), direction: CGVectorMake(1, 1)),
            indexIn: 0.2,
            indexOut: 1)!
        println("\n\n\n(\(rayOut.startPoint.x), \(rayOut.startPoint.y)) --> direction: (\(rayOut.direction.dx), \(rayOut.direction.dy))\n\n\n")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
