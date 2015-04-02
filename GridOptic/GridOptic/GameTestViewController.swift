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
    
    @IBOutlet var directionSlider: UISlider?
    
    var grid: GOGrid?
    var object: GOOpticRep?
    var shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.addSublayer(shapeLayer)
        shapeLayer.strokeEnd = 1.0
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineWidth = 2.0
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.grayColor()
        self.grid = GOGrid(width: 64, height: 48, andUnitLength: 16)
        
        if self.object == nil {
            self.directionSlider?.userInteractionEnabled = false
            self.directionSlider?.alpha = 0
        }
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("didSwipe:"))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeGesture)
        self.directionSlider?.addTarget(self, action: "updateObjectDirection:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func updateObjectDirection(sender: UISlider) {
        self.object?.setDirection(CGVector.vectorFromXPlusRadius(CGFloat(sender.value)))
        drawInitContent()
    }

    
    override func viewDidAppear(animated: Bool) {
        drawInitContent()
    }
    
    func drawInitContent() {
        if let opticRep = self.object {
            shapeLayer.path = opticRep.bezierPath.CGPath
        } else {
            self.setUpGrid()
            self.drawGrid()
            self.drawRay()
        }
    }
    
    private func setUpGrid() {
        let mirror = GOFlatMirrorRep(center: GOCoordinate(x: 32, y: 24), thickness: 2, length: 6, direction: CGVectorMake(1, 1), id: "MIRROR_1")
//        self.grid?.addInstrument(mirror)
        let flatLens = GOFlatLensRep(center: GOCoordinate(x: 32, y: 31), thickness: 8, length: 8, direction: CGVectorMake(1, 0), refractionIndex: 1.33, id: "FLAT_LENS_1")
//        self.grid?.addInstrument(flatLens)
        let concaveLens = GOConcaveLensRep(center: GOCoordinate(x: 20, y: 15), direction: CGVectorMake(1, 4), thicknessCenter: 1, thicknessEdge: 3, curvatureRadius: 5, id: "CONCAVE_LENS_1", refractionIndex: 0.8)
//        self.grid?.addInstrument(concaveLens)
        let convexLens = GOConvexLensRep(center: GOCoordinate(x: 44, y: 25), direction: CGVectorMake(0, -1), thickness: 2, curvatureRadius: 3, id: "CONVEX_LENS_1", refractionIndex: 1.8)
//        self.grid?.addInstrument(convexLens)
    }
    
    private func drawGrid() {
        for (id, instrument) in self.grid!.instruments {
            let layer = self.getPreviewShapeLayer()
            layer.path = self.grid!.getInstrumentDisplayPathForID(id)?.CGPath
            self.view.layer.addSublayer(layer)
        }
    }
    
    private func drawRay() {
        let ray = GORay(startPoint: CGPoint(x:0.1, y: 24), direction: CGVector(dx: 1, dy: 0))
        let layer = self.getPreviewShapeLayer()
        println("before path calculation")
        let path = self.grid!.getRayPath(ray)
        println("after path calculation")
        println(path.CGPath)
        layer.path = path.CGPath
        self.view.layer.addSublayer(layer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.fromValue = 0.0;
        pathAnimation.toValue = 1.0;
        pathAnimation.duration = 3.0;
        pathAnimation.repeatCount = 1.0
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

        layer.addAnimation(pathAnimation, forKey: "strokeEnd")
    }
    
    private func getPreviewShapeLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.strokeEnd = 1.0
        layer.strokeColor = UIColor.whiteColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineWidth = 2.0
        return layer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSwipe(sender: UISwipeGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setUp(object: GOOpticRep?) {
        self.object = object
    }
}

