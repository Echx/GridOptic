//
//  GameTestViewController.swift
//  GridOptic
//
//  Created by Lei Mingyu on 01/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import SpriteKit

class GameTestViewController: UIViewController {
    
    var grid: GOGrid?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.grayColor()
        self.grid = GOGrid(width: 512,
            height: 384,
            andUnitLength: 2)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("didSwipe:"))
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        drawLight()
    }
    
    func drawLight() {
        let ray = GORay(startPoint: CGPoint(x: 0, y: 50), direction: CGVector(dx: 1, dy: 0))
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: ray.startPoint.x, y: ray.startPoint.y))
        path.addLineToPoint(CGPoint(x: 700, y: 300))
        path.closePath()
//        path.lineWidth = 16
//        UIColor.whiteColor().setStroke()
//        path.stroke()
        
        
        var shapeLayer = CAShapeLayer()
        shapeLayer.strokeEnd = 1.0
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.lineWidth = 2.0
        self.view.layer.addSublayer(shapeLayer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.fromValue = 0.0;
        pathAnimation.toValue = 1.0;
        pathAnimation.duration = 3.0;
        pathAnimation.repeatCount = 1.0
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        shapeLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSwipe(sender: UISwipeGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

