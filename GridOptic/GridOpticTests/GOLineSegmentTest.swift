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
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

    
    func testIntersection() {
        let inputRay = GORay(startPoint: CGPoint(x: 8, y: 7), direction: CGVector(dx: 1, dy: 2))
        let mirror = GOLineSegment(center: GOCoordinate.GOCoordinateMake(10, y: 8), length: 10, direction: CGVector(dx: 1, dy: 0))
        XCTAssertEqual(mirror.isIntersacedWithRay(inputRay), true, "They should intersected!")
    }
    
    func testReflection() {
        let inputRay = GORay(startPoint: CGPoint(x: 0, y: 0), direction: CGVector(dx: 1, dy: 1))
        let mirror = GOLineSegment(center: GOCoordinate.GOCoordinateMake(7, y: 10), length: 10, direction: CGVector(dx: 1, dy: 0))
        let outRay = mirror.getRefelctionRay(inputRay)!
        println("Direction of out array: \(outRay.direction.angleFromXPlus)\n")
        XCTAssertEqual(outRay.direction.angleFromXPlus, CGFloat(7 * M_PI / 4), "The reflection ray is wrong!")
    }

}
