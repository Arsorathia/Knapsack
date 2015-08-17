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
                item.userData = NSMutableDictionary(dictionary: ["weight":12.2, "value": Int(arc4random_uniform(100)), "shelfPlace": i, "location" : "shelf"])
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
    var itemInCenter: SKNode?
    var centerDragStarted:Bool?
    
    func itemStartTouched(touch:UITouch, touchedNode:SKNode) -> Void {
        
        touchStarted = touch.timestamp
    }
    
    func itemEndTouched(touch:UITouch, touchedNode:SKNode) -> Void {
        
        if touchStarted != nil {
            
            let timeEnded = touch.timestamp
                if timeEnded - touchStarted! >= longTapTime {
                    itemLongTapped(touchedNode)
                } else {
                    itemShortTapped(touchedNode)
                }
            }
        }
    
    func itemShortTapped(touchedNode:SKNode) -> Void {
        
        if itemInCenter == nil {
            
            moveItemToCenter(touchedNode)

        } else {
            let nodeLocation = touchedNode.userData?["location"]
            if nodeLocation! as! String == "center" {
                
                print("Center Node Touched")
                
            } else {
                
                swapCenterItem(touchedNode)
                
            }

        }
        
    }
    
    
    func moveItemToCenter( touchedNode:SKNode) -> Void{
        
        let moveToCenter:SKAction = SKAction.moveTo(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)), duration: 1)
        let scaleUp:SKAction = SKAction.scaleBy(2, duration: 1)
        touchedNode.runAction(SKAction.group([moveToCenter, scaleUp]))
        touchedNode.userData?["location"] = "center"
        itemInCenter = touchedNode
        
    }
    
    func swapCenterItem(touchedNode:SKNode) -> Void{
       
        let originalPosition = Int(itemInCenter!.userData?["shelfPlace"] as! NSNumber)
        let originalCoord = CGPointMake((CGRectGetMidX(self.frame) - 150 + CGFloat(60*originalPosition)), CGRectGetMidY(self.frame) + 150)
        let moveToShelf:SKAction = SKAction.moveTo(originalCoord, duration: 1)
        let scaleBack:SKAction = SKAction.scaleBy(0.5, duration: 1)
        itemInCenter?.runAction(SKAction.group([moveToShelf, scaleBack]))
        itemInCenter?.userData?["location"] = "shelf"
        moveItemToCenter(touchedNode)

    }
    
    func itemLongTapped(touchedNode:SKNode) -> Void {
        
        let valueOfItem = touchedNode.userData?["value"]
        print("Item of value \(valueOfItem!) was long touched")
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
            if centerDragStarted == true {
                snapBackfromCenterDrag(touchedNode, touch: touch)
            }
            centerDragStarted = false
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            if (touchedNode.userData != nil) {
                let nodeLocation = touchedNode.userData?["location"]
                if nodeLocation! as! String == "center" {
                   centerDrag(touchedNode, touch: touch)
                }
            }

        }
    }
    
    func centerDrag(touchedNode:SKNode, touch:UITouch){
        let location = touch.locationInNode(self)
        touchedNode.position = location
        centerDragStarted = true
    }
    
    func snapBackfromCenterDrag(touchedNode:SKNode, touch:UITouch){
     
        let moveToCenter:SKAction = SKAction.moveTo(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)), duration: 0.1)
        touchedNode.runAction(moveToCenter)
        
    }
    
    
}
