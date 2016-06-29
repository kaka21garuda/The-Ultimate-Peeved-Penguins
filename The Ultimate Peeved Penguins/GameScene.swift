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
    var catapult: SKSpriteNode!
    var levelNode: SKNode!
    var buttonRestart : MSButtonNode!
    var cantileverNode: SKSpriteNode!
    
    //camera helpers
    var cameraTarget: SKNode!
    
    override func didMoveToView(view: SKView) {
        /* Set reference to catapultArm node */
        catapultArm = childNodeWithName("catapultArm") as! SKSpriteNode
        catapult = childNodeWithName("catapult") as! SKSpriteNode
        levelNode = childNodeWithName("//levelNode")
        buttonRestart = childNodeWithName("//buttonRestart") as! MSButtonNode
        cantileverNode = childNodeWithName("cantileverNode") as! SKSpriteNode
        
        /* Load Level 1 */
        let resourcePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "sks")
        let newLevel = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(newLevel)
        buttonRestart.selectedHandler = {
            
            //reference for our spritekit view
            let skView = self.view as! SKView!
            //load game scene
            let scene = GameScene(fileNamed: "GameScene") as! GameScene!
            //ensure correct aspect node
            scene.scaleMode = .AspectFill
            
            //let the game starts
            skView.presentScene(scene)
        
        }
        //create catapult catapultArmBody physical body of type alpha
        let catapultArmBody = SKPhysicsBody(texture: catapultArm!.texture!, size: catapultArm!.size)
        //sets mass
        catapultArmBody.mass = 0.5
        //affected by gravity
        catapultArmBody.affectedByGravity = true
        //improves physics collision
        catapultArmBody.usesPreciseCollisionDetection = true
        //Assigns the physics body to the catapult arm
        catapultArm.physicsBody = catapultArmBody
        
        /* Pin joint catapult and catapult arm */
        let catapultPinJoint = SKPhysicsJointPin.jointWithBodyA(catapult.physicsBody!, bodyB: catapultArm.physicsBody!, anchor: CGPoint(x:220 ,y:105))
        physicsWorld.addJoint(catapultPinJoint)
        //Spring join catapult arm and cantilever node
        /* Spring joint catapult arm and cantilever node */
        let catapultJointSpring = SKPhysicsJointSpring.jointWithBodyA(catapultArm.physicsBody!, bodyB: cantileverNode.physicsBody!, anchorA: catapultArm.position + CGPoint(x:15, y:30), anchorB: cantileverNode.position)
        physicsWorld.addJoint(catapultJointSpring)
        
        catapultJointSpring.frequency = 1.5
        
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
        
        //ask the camera to follow penguins
        cameraTarget = penguin.avatar
        /*
         Now that you have a target for the camera, you need to update the camera's position to follow the target.
         */
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //Checked wether we have a valid camera target to follow or not
        if let cameraTarget = cameraTarget {
            /* Set camera position to follow target horizontally, keep vertical locked */
            camera?.position = CGPoint(x:cameraTarget.position.x, y:camera!.position.y)
            /* Clamp camera scrolling to our visible scene area only */
            camera?.position.x.clamp(283, 677)
        }
    }
    
}