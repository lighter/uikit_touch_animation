//
//  ViewController.swift
//  uikit_touch_animation
//
//  Created by lighter on 2014/8/23.
//  Copyright (c) 2014年 lighter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var greenBox: UIView?

    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    var collision: UICollisionBehavior?
    var panGesture: UIPanGestureRecognizer?
    var attach: UIAttachmentBehavior?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.greenBox = UIView()
        self.greenBox!.backgroundColor = UIColor.greenColor()
        self.greenBox!.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 50, CGRectGetMidY(self.view.frame) - 50, 100, 100)

        self.view.addSubview(self.greenBox!)

        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.gravity = UIGravityBehavior(items: [self.greenBox!])


        self.collision = UICollisionBehavior(items: [self.greenBox!])
        self.collision!.translatesReferenceBoundsIntoBoundary = true


        self.animator!.addBehavior(self.gravity!)
        self.animator!.addBehavior(self.collision!)

        self.panGesture = UIPanGestureRecognizer(target: self, action: "panning:")
        self.greenBox!.addGestureRecognizer(panGesture!)
    }

    func panning(pan: UIPanGestureRecognizer)
    {
        println("Our box is panning...")

        var location = pan.locationInView(self.view)
        var touchLocation = pan.locationInView(self.greenBox)

        if pan.state == UIGestureRecognizerState.Began {
            self.animator!.removeAllBehaviors()

            var offset = UIOffsetMake(touchLocation.x - CGRectGetMidX(self.greenBox!.bounds), touchLocation.y - CGRectGetMidY(self.greenBox!.bounds))
            self.attach = UIAttachmentBehavior(item: self.greenBox, offsetFromCenter: offset, attachedToAnchor: location)
            self.animator!.addBehavior(self.attach)
        }
        else if pan.state == UIGestureRecognizerState.Changed {
            self.attach!.anchorPoint = location
        }
        else if pan.state == UIGestureRecognizerState.Ended {
            self.animator!.removeBehavior(self.attach)

            var itemBehavior = UIDynamicItemBehavior(items: [self.greenBox!])
            itemBehavior.addLinearVelocity(pan.velocityInView(self.view), forItem: self.greenBox)
            itemBehavior.angularResistance = 0
            itemBehavior.elasticity = 0.8
            self.animator!.addBehavior(itemBehavior)

            self.animator!.addBehavior(self.gravity)
            self.animator!.addBehavior(self.collision)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

