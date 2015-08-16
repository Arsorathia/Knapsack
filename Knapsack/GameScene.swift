//
//  GameScene.swift
//  Knapsack
//
//  Created by Arif Sorathia on 8/15/15.
//  Copyright (c) 2015 Arif Sorathia. All rights reserved.
//

import SpriteKit

let timeOver:NSTimeInterval = 30

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        createScene()
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func createScene(){
        
        self.addTimerBar()
        self.addItems()
        
    }
    
    func newTimerBar() -> SKSpriteNode {
        let bar = SKSpriteNode(color: SKColor.greenColor(), size: CGSizeMake(250, 32))
        let shrink:SKAction = SKAction.scaleXBy(0, y: 1, duration:timeOver)
        let colorShift:SKAction = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 5, duration: timeOver )
        bar.runAction(SKAction.group([shrink, colorShift]), completion:{self.gameOver()})
        return bar
    }
    
    func newItem() -> SKSpriteNode {
       let item = SKSpriteNode(color: SKColor.purpleColor(), size: CGSizeMake(50, 50))
        return item
    }
    
    func addItems(){
        for var i = 0; i <= 5; i++
            {
                let item:SKSpriteNode = newItem()
                item.position = CGPointMake((CGRectGetMidX(self.frame) - 150 + CGFloat(60*i)), CGRectGetMidY(self.frame) + 150)
                item.userData = NSMutableDictionary(dictionary: ["weight":12.2, "value": i])
                item.name = "item"
                self.addChild(item)
            }
    }
    
    func gameOver(){
        self.removeAllChildren()
        let helloNode:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        helloNode.text = "Game Over!"
        helloNode.fontSize = 42
        helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        helloNode.userInteractionEnabled = false
        helloNode.name = "gameOverTag"
        let playAgain:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        playAgain.text = "Try Again"
        playAgain.fontSize = 32
        playAgain.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-42)
        playAgain.userInteractionEnabled = false
        playAgain.name = "playAgainTag"
        let takeHome:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        takeHome.text = "Back to Home"
        takeHome.fontSize = 32
        takeHome.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-84)
        takeHome.userInteractionEnabled = false
        takeHome.name = "takeHomeTag"
        self.addChild(helloNode)
        self.addChild(playAgain)
        self.addChild(takeHome)
    }
    
    func addTimerBar(){
        let bar:SKSpriteNode = newTimerBar()
        bar.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 150)
        self.addChild(bar)
    }
    
    func playAgain(){
        
        self.removeAllChildren()
        self.createScene()
        
    }
    
    func takeHome(){
        
        let homeScene:SKScene = HomeScene(size: self.size)
        let transition:SKTransition = SKTransition.doorsOpenVerticalWithDuration(0.5)
        self.view!.presentScene(homeScene, transition: transition)
        
    }
    
    var touchStarted: NSTimeInterval?
    let longTapTime: NSTimeInterval = 0.5
    
    func itemStartTouched(touch:UITouch, touchedNode:SKNode) -> Void {
        
        touchStarted = touch.timestamp
    }
    
    func itemEndTouched(touch:UITouch, touchedNode:SKNode) -> Void {
        
        if touchStarted != nil {
            
            let timeEnded = touch.timestamp
                if timeEnded - touchStarted! >= longTapTime {
                    itemLongTapped(touchedNode)
                } else {
                    print("Short Tap")
                }
            }
        }
    
    func itemLongTapped(touchedNode:SKNode) -> Void {
        
        let valueOfItem = touchedNode.userData?["value"]
        print("Item of value \(valueOfItem!) was touched")
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
            if let name = touchedNode.name  {
                    switch (name){
                        case "gameOverTag" : print("Game Over")
                        case "playAgainTag" : playAgain()
                        case "takeHomeTag" : takeHome()
                        case "item" : itemStartTouched(touch,touchedNode: touchedNode)
                        default: print("Other Click")
                        }
                    }
                }
            }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
            if let name = touchedNode.name  {
                switch (name){
                case "item" : itemEndTouched(touch,touchedNode: touchedNode)
                default: print("Other End Click")
                }
            }
            touchStarted = nil
        }
    }
    
    
    
}
