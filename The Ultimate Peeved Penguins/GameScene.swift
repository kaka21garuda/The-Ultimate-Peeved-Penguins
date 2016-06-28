//
//  GameScene.swift
//  The Ultimate Peeved Penguins
//
//  Created by Buka Cakrawala on 6/28/16.
//  Copyright (c) 2016 Buka Cakrawala. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    /* Game object connections */
    var catapultArm: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Set reference to catapultArm node */
        catapultArm = childNodeWithName("catapultArm") as! SKSpriteNode
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Add a new penguin to the scene */
        let resourcePath = NSBundle.mainBundle().pathForResource("Penguin", ofType: "sks")
        let penguin = MSReferenceNode(URL: NSURL (fileURLWithPath: resourcePath!))
        addChild(penguin)
        
        /* Move penguin to the catapult bucket area */
        penguin.avatar.position = catapultArm.position + CGPoint(x: 32, y: 50)
        
        /*
         It would be nice to add a little impulse to the penguin. Imagine
         the penguin is being hit by an invisible baseball bat.
         */
        //Impulse Vector
        let launchDirection = CGVector(dx: 1, dy: 0)
        let force = launchDirection * 280
        
        //Applying impulse to Penguin
        penguin.avatar.physicsBody?.applyImpulse(force)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}