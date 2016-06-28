//
//  MainScene.swift
//  The Ultimate Peeved Penguins
//
//  Created by Buka Cakrawala on 6/28/16.
//  Copyright © 2016 Buka Cakrawala. All rights reserved.
//

import SpriteKit

class MainScene: SKScene {
    
    //Creating UI connection
    var buttonPlay: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        //Setting up your scene here!
        
        //Set up UI connection
        buttonPlay = self.childNodeWithName("buttonPlay") as! MSButtonNode
        
        //Set up Restart button with selection handler
        buttonPlay.selectedHandler = {
            //Grab reference to our SpriteKit view
            let skView = self.view as! SKView!
            //load game scene
            let scene = GameScene(fileNamed:"GameScene") as! GameScene!
            //ensure correct aspect mode
            scene.scaleMode = .AspectFill
            
            /* Show debug
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            */
            
            //start game scene
            skView.presentScene(scene)
        }
    }
}
