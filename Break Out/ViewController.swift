//
//  ViewController.swift
//  Break Out
//
//  Created by mkelly2 on 2/26/16.
//  Copyright © 2016 mkelly2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var livesLabel: UILabel!
    var dynamicAnimator = UIDynamicAnimator()
    var paddle = UIView()
    var ball = UIView()
    var ballBehavior = UIDynamicItemBehavior()
    var blocks: [UIView] = []
    var allObjects : [UIView] = []
    var collisionBehavior = UICollisionBehavior()
    var lives = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
       
    }
    @IBAction func dragPaddle(sender: UIPanGestureRecognizer) {
        paddle.center = CGPointMake(sender.locationInView(view).x, paddle.center.y)
        dynamicAnimator.updateItemUsingCurrentState(paddle)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if item.isEqual(ball) && p.y > paddle.center.y {
            lives--
            if lives > 0 {
                livesLabel.text = "Lives: \(lives)"
                ball.center = view.center
                dynamicAnimator.updateItemUsingCurrentState(ball)
            }
            else {
                gameOver("You Lost")
            }
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        var hiddenBlockCount = 0
        for block in blocks {
            if item1.isEqual(ball) && item2.isEqual(block) {
                if block.backgroundColor == UIColor.purpleColor() {
                    block.backgroundColor = UIColor.greenColor()
                }
                else if block.backgroundColor == UIColor.blueColor() {
                    block.backgroundColor = UIColor.purpleColor()
                }
                else {
                    block.hidden = true
                    collisionBehavior.removeItem(block)
                }
                ballBehavior.addLinearVelocity(CGPointMake(0, 10), forItem: ball)
            }
            if block.hidden == true {
                hiddenBlockCount++
            }
        }
        if hiddenBlockCount == blocks.count {
          gameOver("You Won")
        }
    }
    func resetGame() {
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        allObjects = []
        
        paddle = UIView(frame: CGRectMake(view.center.x, view.center.y * 1.7, 80 , 20))
        paddle.backgroundColor = UIColor.redColor()
        view.addSubview(paddle)
        
        ball = UIView(frame: CGRectMake(view.center.x, view.center.y, 20, 20))
        ball.layer.cornerRadius = 10
        ball.backgroundColor = UIColor.blackColor()
        view.addSubview(ball)
        
        let pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.pushDirection = CGVectorMake(0.5, 1.0)
        pushBehavior.magnitude = 0.15
        dynamicAnimator.addBehavior(pushBehavior)
        
        let paddleBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleBehavior.density = 10000
        paddleBehavior.resistance = 100
        paddleBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(paddleBehavior)
        allObjects.append(paddle)
    
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0
        ballDynamicBehavior.resistance = 0
        ballDynamicBehavior.elasticity = 1.0
        ballDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        allObjects.append(ball)
        
        let width = (Int)(view.bounds.size.width - 40)
        let margin = ((Int)(view.bounds.size.width) % 42)/2
        for var x = margin; x < width; x += 42 {addBlock(x, y: 40, color: UIColor.blueColor())}
        for var x = margin; x < width; x += 42 {addBlock(x, y: 62, color: UIColor.purpleColor())}
        for var x = margin; x < width; x += 42 {addBlock(x, y: 84, color: UIColor.purpleColor())}
        for var x = margin; x < width; x += 42 {addBlock(x, y: 106, color: UIColor.purpleColor())}
        for var x = margin; x < width; x += 42 {addBlock(x, y: 128, color: UIColor.purpleColor())}
        for var x = margin; x < width; x += 42 {addBlock(x, y: 150 , color: UIColor.greenColor())}
        for var x = margin; x < width; x += 42 {addBlock(x, y: 172, color: UIColor.greenColor())}
        for var x = margin; x < width; x += 42 {addBlock(x, y: 194, color: UIColor.greenColor())}
        
        let blockBehavior = UIDynamicItemBehavior(items: blocks)
        blockBehavior.allowsRotation = false
        blockBehavior.density = 1000
        blockBehavior.elasticity = 1.0
        dynamicAnimator.addBehavior(blockBehavior)
        
        collisionBehavior = UICollisionBehavior(items: allObjects)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = UICollisionBehaviorMode.Everything
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        
        lives = 5
        livesLabel.text = "Lives: \(lives)"

    }
    
    func gameOver(message :String) {
        ball.removeFromSuperview()
        collisionBehavior.removeItem(ball)
        dynamicAnimator.updateItemUsingCurrentState(ball)
        paddle.removeFromSuperview()
        collisionBehavior.removeItem(paddle)
        dynamicAnimator.updateItemUsingCurrentState(paddle)
        
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let resetAction = UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.resetGame()
        }
        alert.addAction(resetAction)
        
        let quitAction = UIAlertAction(title: "Quit", style: UIAlertActionStyle.Default) { (action) -> Void in
            exit(0)
        }
        alert.addAction(quitAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func addBlock(x: Int, y: Int, color: UIColor) {
        let block = UIView(frame: CGRectMake((CGFloat)(x),(CGFloat)(y), 40,20))
        block.backgroundColor = color
        view.addSubview(block)
        blocks.append(block)
        allObjects.append(block)
    }
}
