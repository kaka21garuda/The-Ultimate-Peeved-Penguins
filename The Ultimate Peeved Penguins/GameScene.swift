//
//  GameScene.swift
//  The Ultimate Peeved Penguins
//
//  Created by Buka Cakrawala on 6/28/16.
//  Copyright (c) 2016 Buka Cakrawala. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /* Game object connections */
    var catapultArm: SKSpriteNode!
    var catapult: SKSpriteNode!
    var levelNode: SKNode!
    var buttonRestart : MSButtonNode!
    var cantileverNode: SKSpriteNode!
    var touchNode: SKSpriteNode!
    //physics helper
    var touchJoint: SKPhysicsJointSpring?
    //pining the penguin
    var penguinJoint: SKPhysicsJointPin?
    
    
    //camera helpers
    var cameraTarget: SKNode!
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
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
            scene.scaleMode = .AspectFit
            
            //let the game starts
            skView.presentScene(scene)
        
        }
        //create catapult catapultArmBody physical body of type alpha
        let catapultArmBody = SKPhysicsBody(texture: catapultArm!.texture!, size: catapultArm!.size)
        //sets mass
        catapultArmBody.mass = 0.5
        //affected by gravity
        catapultArmBody.affectedByGravity = false
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
        /* Add a new penguin to the scene */
        let resourcePath = NSBundle.mainBundle().pathForResource("Penguin", ofType: "sks")
        let penguin = MSReferenceNode(URL: NSURL (fileURLWithPath: resourcePath!))
        addChild(penguin)
        
        /* Position penguin in the catapult bucket area */
        penguin.avatar.position = catapultArm.position + CGPoint(x: 32, y: 50)
        
        /* Improves physics collision handling of fast moving objects */
        penguin.avatar.physicsBody?.usesPreciseCollisionDetection = true
        
        /* Setup pin joint between penguin and catapult arm */
        penguinJoint = SKPhysicsJointPin.jointWithBodyA(catapultArm.physicsBody!, bodyB: penguin.avatar.physicsBody!, anchor: penguin.avatar.position)
        physicsWorld.addJoint(penguinJoint!)
        
        /* Set camera to follow penguin */
        cameraTarget = penguin.avatar
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
            
            /* Check penguin has come to rest */
            if cameraTarget.physicsBody?.joints.count == 0 && cameraTarget.physicsBody?.velocity.length() < 0.18 {
                
                cameraTarget.removeFromParent()
                
                /* Reset catapult arm */
                catapultArm.physicsBody?.velocity = CGVector(dx:0, dy:0)
                catapultArm.physicsBody?.angularVelocity = 0
                catapultArm.zRotation = 0
                
                /* Reset camera */
                let cameraReset = SKAction.moveTo(CGPoint(x:284, y:camera!.position.y), duration: 1.5)
                let cameraDelay = SKAction.waitForDuration(0.5)
                let cameraSequence = SKAction.sequence([cameraDelay,cameraReset])
                
                camera?.runAction(cameraSequence)
            }
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
        if let penguinJoint = penguinJoint {physicsWorld.removeJoint(penguinJoint)}
    }
    func didBeginContact(contact: SKPhysicsContact) {
        //physics contact delegation
        //Get reference to the bodies involved collision
        let contactA: SKPhysicsBody = contact.bodyA
        let contactB: SKPhysicsBody = contact.bodyB
        
        //Get reference to the physics body parent SKSpriteNode
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
        if contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2 {
            //was the collision more than a gentle nudge?
            if contact.collisionImpulse > 2.0 {
                //kill seals
                if contactA.categoryBitMask == 2 { dieSeal(nodeA) }
                if contactB.categoryBitMask == 2 { dieSeal(nodeB)}
            }
        }
    }
    func dieSeal(node: SKNode) {
        //load our particle effect
        let particles = SKEmitterNode(fileNamed: "SealExplosion")!
        particles.position = convertPoint(node.position, fromNode: node)
        //Restrict total particles to reduce runtime of particle
        particles.numParticlesToEmit = 25
        //add particles to scene
        addChild(particles)
        
        //Seal Death
        //Create our Hero death action
        let sealDeath = SKAction.runBlock({
            //remove seal node from scene})
            node.removeFromParent()
    })
        self.runAction(sealDeath)
        //play sfx
        let sealSFX = SKAction.playSoundFileNamed("sfx_seal", waitForCompletion: false)
        self.runAction(sealSFX)
   
}

}