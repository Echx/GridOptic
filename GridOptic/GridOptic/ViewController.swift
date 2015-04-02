//
//  ViewController.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc: GameTestViewController = segue.destinationViewController as GameTestViewController
        if segue.identifier == "light" {
            vc.setUp(nil)
        } else if segue.identifier == "flatMirror" {
            vc.setUp(GOFlatMirrorRep(center: GOCoordinate(x: 500, y: 500), thickness: 10, length: 60, direction: CGVector(dx: 1, dy: 2), id: "flat mirror"))
        } else if segue.identifier == "flatWall" {
            vc.setUp(GOFlatWallRep(center: GOCoordinate(x: 500, y: 500), thickness: 10, length: 60, direction: CGVector(dx: 1, dy: 2), id: "flat wall"))
        } else if segue.identifier == "convexLens" {
            vc.setUp(GOConvexLensRep(center: GOCoordinate(x: 500, y: 350), direction: CGVector(dx: 1, dy: 2), thickness: 10, curvatureRadius: 50, id: "convex lens"))
        } else if segue.identifier == "concaveLens" {
            vc.setUp(GOConcaveLensRep(center: GOCoordinate(x: 500, y: 500), direction: CGVector(dx: 0, dy: 1), thicknessCenter: 100, thicknessEdge: 200, curvatureRadius: 500, id: "concave lens"))
        }
    }
}

