//
//  CGFloat+GOUtilitiesTest.swift
//  GridOptic
//
//  Created by NULL on 01/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit
import XCTest

class CGFloat_GOUtilitiesTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDistance() {
        let pointA = CGPointMake(0, 0)
        let pointB = CGPointMake(3, 4)
        let pointC = CGPointMake(6, 8)
        
        XCTAssertEqual(pointA.getDistanceToPoint(pointB), CGFloat(5), "distance wrong")
        XCTAssertEqual(pointA.getDistanceToPoint(pointC), CGFloat(10), "distance wrong")
        XCTAssertEqual(pointC.getDistanceToPoint(pointB), CGFloat(5), "distance wrong")
    }
    
    func testRotation() {
        let pointA = CGPointMake(0, 0)
        let pointB = CGPointMake(1, 1)
        let pointC = CGPointMake(2, 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
