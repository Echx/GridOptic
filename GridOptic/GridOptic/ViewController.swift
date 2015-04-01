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
        let vc: GameTestViewController = sender!.destinationViewController as GameTestViewController
        if segue.identifier == "light" {
            vc.setUp(nil)
        } else if segue.identifier == "flatMirror" {
            vc.setUp(GOFlatMirrorRep(center: GOCoordinate(x: 50, y: 50), thickness: 50, length: 100, direction: CGVector(dx: 1.0, dy: 1.0), id: "flat mirror"))
        }
    }
}

