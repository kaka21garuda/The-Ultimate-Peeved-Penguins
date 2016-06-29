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
    var touchNode: SKSpriteNode!
    //physics helper
    var touchJoint: SKPhysicsJointSpring?
    
    
    //camera helpers
    var cameraTarget: SKNode!
    
    override func didMoveToView(view: SKView) {
        /* Set reference to catapultArm node */
        catapultArm = childNodeWithName("catapultArm") as! SKSpriteNode
        catapult = childNodeWithName("catapult") as! SKSpriteNode
        levelNode = childNodeWithName("//levelNode")
        buttonRestart = childNodeWithName("//buttonRestart") as! MSButtonNode
        cantileverNode = childNodeWithName("cantileverNode") as! SKSpriteNode
        touchNode = childNodeWithName("touchNode") as! SKSpriteNode
        
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
        /* Called when a touch begins */
        
        /* There will only be one touch as multi touch is not enabled by default */
        for touch in touches {
            
            /* Grab scene position of touch */
            let location    = touch.locationInNode(self)
            
            /* Get node reference if we're touching a node */
            let touchedNode = nodeAtPoint(location)
            
            /* Is it the catapult arm? */
            if touchedNode.name == "catapultArm" {
                
                /* Reset touch node position */
                touchNode.position = location
                
                /* Spring joint touch node and catapult arm */
                touchJoint = SKPhysicsJointSpring.jointWithBodyA(touchNode.physicsBody!, bodyB: catapultArm.physicsBody!, anchorA: location, anchorB: location)
                physicsWorld.addJoint(touchJoint!)
                
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //Checked wether we have a valid camera target to follow or not
        if let cameraTarget = cameraTarget {
            /* Set camera position to follow target horizontally, keep ve
             rtical locked */
            camera?.position = CGPoint(x:cameraTarget.position.x, y:camera!.position.y)
            /* Clamp camera scrolling to our visible scene area only */
            camera?.position.x.clamp(283, 677)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //called when touches are moving
        //There'll be only one touch because multi touch is not allowed by default
        for touch in touches {
            //Grab scene position of touch and update touchNode position
            let location = touch.locationInNode(self)
            touchNode.position = location
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //called when touch is ended
        if let touchJoint = touchJoint {physicsWorld.removeJoint(touchJoint)}
    }
    
}