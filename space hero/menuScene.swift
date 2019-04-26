//
//  menuScene.swift
//  space hero
//
//  Created by ouyang chenxing on 4/20/17.
//  Copyright © 2017 Shao-Chiang Tsai. All rights reserved.
//

import Foundation
import SpriteKit

class menuScene :SKScene{
    let startLabel = SKLabelNode()
    let rankingLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        let background1 = SKSpriteNode(imageNamed: "background1")
        background1.size = self.size
        background1.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background1.zPosition = 0
        self.addChild(background1)
        
        let titleLabel = SKLabelNode()
        titleLabel.fontName = "E-SQUARE"
        titleLabel.fontSize = 150
        titleLabel.fontColor = SKColor.white
        titleLabel.text = "SPACE HERO"
        titleLabel.position = CGPoint(x:self.size.width*0.5, y:self.size.height*0.80)
        titleLabel.zPosition = 1
        self.addChild(titleLabel)
        
        startLabel.fontName = "E-SQUARE"
        startLabel.fontSize = 90
        startLabel.fontColor = SKColor.white
        startLabel.text = "START"
        startLabel.position = CGPoint(x:self.size.width*0.5, y:self.size.height*0.4)
        startLabel.zPosition = 1
        self.addChild(startLabel)
        
        rankingLabel.fontName = "E-SQUARE"
        rankingLabel.fontSize = 90
        rankingLabel.fontColor = SKColor.white
        rankingLabel.text = "RANKING"
        rankingLabel.position = CGPoint(x:self.size.width*0.5, y:self.size.height*0.3)
        rankingLabel.zPosition = 1
        self.addChild(rankingLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let touchLocation = touch.location(in: self)
            if  startLabel.contains(touchLocation){
                let gameScreen = GameScene(size:self.size)
                gameScreen.scaleMode = self.scaleMode
                let trans = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(gameScreen, transition: trans)
            }
            
            if  rankingLabel.contains(touchLocation){
                let rankingScene = RankingScene(size:self.size)
                rankingScene.scaleMode = self.scaleMode
                let trans = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(rankingScene, transition: trans)
            }

        }
        
        
    }
    
}
