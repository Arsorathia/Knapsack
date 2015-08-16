//
//  HomeScene.swift
//  Knapsack
//
//  Created by Arif Sorathia on 8/15/15.
//  Copyright © 2015 Arif Sorathia. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        createScene()
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func createScene(){
        
        addHomeWelcome()
    }
    
    func addHomeWelcome(){
        
        let homeWelcome:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        homeWelcome.text = "Welcome Home"
        homeWelcome.fontSize = 42
        homeWelcome.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        homeWelcome.userInteractionEnabled = false
        homeWelcome.name = "gameOverTag"
        self.addChild(homeWelcome)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
            if let name = touchedNode.name  {
                if name == "gameOverTag" {
                    print("Game Over")
                }
                if name == "playAgainTag" {
                    print("Play Again")
                }
            }
            
        }
        
    }
    
}
