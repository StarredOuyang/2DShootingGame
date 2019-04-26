//
//  RankingScene.swift
//  space hero
//
//  Created by Ziwei Zhao on 4/22/17.
//  Copyright © 2017 Shao-Chiang Tsai. All rights reserved.
//

import Foundation
import SpriteKit

class RankingScene: SKScene {
    let backLabel = SKLabelNode()
    let player1Name = SKLabelNode()
    let player2Name = SKLabelNode()
    let player3Name = SKLabelNode()
    let player4Name = SKLabelNode()
    let player5Name = SKLabelNode()
    let player1Score = SKLabelNode()
    let player2Score = SKLabelNode()
    let player3Score = SKLabelNode()
    let player4Score = SKLabelNode()
    let player5Score = SKLabelNode()
    let titleLabel = SKLabelNode()
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let highScoreNumber1 = defaults.integer(forKey: "highScoreNumber1")
        let highScoreNumber2 = defaults.integer(forKey: "highScoreNumber2")
        let highScoreNumber3 = defaults.integer(forKey: "highScoreNumber3")
        let highScoreNumber4 = defaults.integer(forKey: "highScoreNumber4")
        let highScoreNumber5 = defaults.integer(forKey: "highScoreNumber5")
        
        let highScoreName1 = defaults.string(forKey: "highScoreName1")
        let highScoreName2 = defaults.string(forKey: "highScoreName2")
        let highScoreName3 = defaults.string(forKey: "highScoreName3")
        let highScoreName4 = defaults.string(forKey: "highScoreName4")
        let highScoreName5 = defaults.string(forKey: "highScoreName5")
        
        titleLabel.fontName = "E-SQUARE"
        titleLabel.fontSize = 100
        titleLabel.fontColor = SKColor.white
        titleLabel.text = "HERO RANKING"
        titleLabel.position = CGPoint(x:self.size.width*0.5, y:self.size.height*0.8)
        titleLabel.zPosition = 1
        self.addChild(titleLabel)
        
        player1Name.fontName = "E-SQUARE"
        player1Name.fontSize = 80
        player1Name.fontColor = SKColor.white
        player1Name.text = highScoreName1 ?? "???"
        player1Name.position = CGPoint(x:self.size.width*0.4, y:self.size.height*0.65)
        player1Name.zPosition = 1
        self.addChild(player1Name)
        
        player2Name.fontName = "E-SQUARE"
        player2Name.fontSize = 80
        player2Name.fontColor = SKColor.white
        player2Name.text = highScoreName2 ?? "???"
        player2Name.position = CGPoint(x:self.size.width*0.4, y:self.size.height*0.575)
        player2Name.zPosition = 1
        self.addChild(player2Name)
        
        player3Name.fontName = "E-SQUARE"
        player3Name.fontSize = 80
        player3Name.fontColor = SKColor.white
        player3Name.text = highScoreName3 ?? "???"
        player3Name.position = CGPoint(x:self.size.width*0.4, y:self.size.height*0.5)
        player3Name.zPosition = 1
        self.addChild(player3Name)
        
        player4Name.fontName = "E-SQUARE"
        player4Name.fontSize = 80
        player4Name.fontColor = SKColor.white
        player4Name.text = highScoreName4 ?? "???"
        player4Name.position = CGPoint(x:self.size.width*0.4, y:self.size.height*0.425)
        player4Name.zPosition = 1
        self.addChild(player4Name)
        
        player5Name.fontName = "E-SQUARE"
        player5Name.fontSize = 80
        player5Name.fontColor = SKColor.white
        player5Name.text = highScoreName5 ?? "???"
        player5Name.position = CGPoint(x:self.size.width*0.4, y:self.size.height*0.35)
        player5Name.zPosition = 1
        self.addChild(player5Name)
        
        player1Score.fontName = "E-SQUARE"
        player1Score.fontSize = 80
        player1Score.fontColor = SKColor.white
        player1Score.text = String(highScoreNumber1)
        player1Score.position = CGPoint(x:self.size.width*0.7, y:self.size.height*0.65)
        player1Score.zPosition = 1
        self.addChild(player1Score)
        
        player2Score.fontName = "E-SQUARE"
        player2Score.fontSize = 80
        player2Score.fontColor = SKColor.white
        player2Score.text = String(highScoreNumber2)
        player2Score.position = CGPoint(x:self.size.width*0.7, y:self.size.height*0.575)
        player2Score.zPosition = 1
        self.addChild(player2Score)
        
        player3Score.fontName = "E-SQUARE"
        player3Score.fontSize = 80
        player3Score.fontColor = SKColor.white
        player3Score.text = String(highScoreNumber3)
        player3Score.position = CGPoint(x:self.size.width*0.7, y:self.size.height*0.5)
        player3Score.zPosition = 1
        self.addChild(player3Score)
        
        player4Score.fontName = "E-SQUARE"
        player4Score.fontSize = 80
        player4Score.fontColor = SKColor.white
        player4Score.text = String(highScoreNumber4)
        player4Score.position = CGPoint(x:self.size.width*0.7, y:self.size.height*0.425)
        player4Score.zPosition = 1
        self.addChild(player4Score)
        
        player5Score.fontName = "E-SQUARE"
        player5Score.fontSize = 80
        player5Score.fontColor = SKColor.white
        player5Score.text = String(highScoreNumber5)
        player5Score.position = CGPoint(x:self.size.width*0.7, y:self.size.height*0.35)
        player5Score.zPosition = 1
        self.addChild(player5Score)
        
        backLabel.fontName = "E-SQUARE"
        backLabel.fontSize = 100
        backLabel.fontColor = SKColor.white
        backLabel.text = "BACK"
        backLabel.position = CGPoint(x:self.size.width*0.5, y:self.size.height*0.2)
        backLabel.zPosition = 1
        self.addChild(backLabel)
        

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let touchLocation = touch.location(in: self)
            if  backLabel.contains(touchLocation){
                let menuScreen = menuScene(size:self.size)
                menuScreen.scaleMode = self.scaleMode
                let trans = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(menuScreen, transition: trans)
                
            }
        }
        
        
    }
}
