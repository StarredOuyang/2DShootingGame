//
//  gameEnd.swift
//  space hero
//
//  Created by ouyang chenxing on 4/20/17.
//  Copyright © 2017 Shao-Chiang Tsai. All rights reserved.
//

import Foundation
import SpriteKit

let defaults = UserDefaults()

class gameEnd :SKScene{
    let restartLabel = SKLabelNode()
    let submitLabel = SKLabelNode()
    let username = UITextField()
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let loseLabel = SKLabelNode()
        loseLabel.fontName = "E-SQUARE"
        loseLabel.fontSize = 150
        loseLabel.fontColor = SKColor.white
        loseLabel.text = "YOU LOSE"
        loseLabel.position = CGPoint(x:self.size.width*0.5, y:self.size.height*0.85)
        loseLabel.zPosition = 1
        self.addChild(loseLabel)
        
        let finalScoreLabel = SKLabelNode()
        finalScoreLabel.fontName = "E-SQUARE"
        finalScoreLabel.fontSize = 70
        finalScoreLabel.fontColor = SKColor.white
        finalScoreLabel.text = "YOUR FINAL SCORE IS : \(score)"
        finalScoreLabel.position = CGPoint(x:self.size.width*0.5, y:self.size.height*0.75)
        finalScoreLabel.zPosition = 1
        self.addChild(finalScoreLabel)
        
        //asking for a username after the game, need to save it
        username.frame = CGRect(x:self.size.width/2, y:self.size.height*0.7, width:200, height:20)
        username.center = (self.view?.center)!
        username.backgroundColor = UIColor.white
        username.textColor = UIColor.black
        username.font = UIFont(name: "E-SQUARE", size: 30)
        username.placeholder = "Hero name"
        self.view?.addSubview(username)
        
        
        restartLabel.fontName = "E-SQUARE"
        restartLabel.fontSize = 50
        restartLabel.fontColor = SKColor.white
        restartLabel.text = "RESTART"
        restartLabel.position = CGPoint(x:self.size.width*0.25, y:self.size.height*0.6)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
        submitLabel.fontName = "E-SQUARE"
        submitLabel.fontSize = 50
        submitLabel.fontColor = SKColor.white
        submitLabel.text = "SUBMIT"
        submitLabel.position = CGPoint(x:self.size.width*0.75, y:self.size.height*0.6)
        submitLabel.zPosition = 1
        self.addChild(submitLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let touchLocation = touch.location(in: self)
            if  restartLabel.contains(touchLocation){
                self.username.removeFromSuperview()
                let gameScreen = GameScene(size:self.size)
                gameScreen.scaleMode = self.scaleMode
                let trans = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(gameScreen, transition: trans)
                
            }
            if  submitLabel.contains(touchLocation){
                var highScoreNumber1 = defaults.integer(forKey: "highScoreNumber1")
                var highScoreNumber2 = defaults.integer(forKey: "highScoreNumber2")
                var highScoreNumber3 = defaults.integer(forKey: "highScoreNumber3")
                var highScoreNumber4 = defaults.integer(forKey: "highScoreNumber4")
                var highScoreNumber5 = defaults.integer(forKey: "highScoreNumber5")
                
                var highScoreName1 = defaults.string(forKey: "highScoreName1")
                var highScoreName2 = defaults.string(forKey: "highScoreName2")
                var highScoreName3 = defaults.string(forKey: "highScoreName3")
                var highScoreName4 = defaults.string(forKey: "highScoreName4")
                var highScoreName5 = defaults.string(forKey: "highScoreName5")
                
                if (score > highScoreNumber1){
                    highScoreNumber5 = highScoreNumber4
                    highScoreNumber4 = highScoreNumber3
                    highScoreNumber3 = highScoreNumber2
                    highScoreNumber2 = highScoreNumber1
                    highScoreNumber1 = score
                    highScoreName5 = highScoreName4
                    highScoreName4 = highScoreName3
                    highScoreName3 = highScoreName2
                    highScoreName2 = highScoreName1
                    highScoreName1 = username.text ?? "No Name"
                }
                else if (score > highScoreNumber2){
                    highScoreNumber5 = highScoreNumber4
                    highScoreNumber4 = highScoreNumber3
                    highScoreNumber3 = highScoreNumber2
                    highScoreNumber2 = score
                    highScoreName5 = highScoreName4
                    highScoreName4 = highScoreName3
                    highScoreName3 = highScoreName2
                    highScoreName2 = username.text ?? "No Name"
                }
                else if (score > highScoreNumber3){
                    highScoreNumber5 = highScoreNumber4
                    highScoreNumber4 = highScoreNumber3
                    highScoreNumber3 = score
                    highScoreName5 = highScoreName4
                    highScoreName4 = highScoreName3
                    highScoreName3 = username.text ?? "No Name"
                }
                else if (score > highScoreNumber4){
                    highScoreNumber5 = highScoreNumber4
                    highScoreNumber4 = score
                    highScoreName5 = highScoreName4
                    highScoreName4 = username.text ?? "No Name"
                }
                else if (score > highScoreNumber5){
                    highScoreNumber5 = score
                    highScoreName5 = username.text ?? "No Name"
                }
                defaults.set(highScoreNumber1, forKey: "highScoreNumber1")
                defaults.set(highScoreNumber2, forKey: "highScoreNumber2")
                defaults.set(highScoreNumber3, forKey: "highScoreNumber3")
                defaults.set(highScoreNumber4, forKey: "highScoreNumber4")
                defaults.set(highScoreNumber5, forKey: "highScoreNumber5")
                defaults.set(highScoreName1, forKey: "highScoreName1")
                defaults.set(highScoreName2, forKey: "highScoreName2")
                defaults.set(highScoreName3, forKey: "highScoreName3")
                defaults.set(highScoreName4, forKey: "highScoreName4")
                defaults.set(highScoreName5, forKey: "highScoreName5")
                self.username.removeFromSuperview()
                let menuScreen = menuScene(size:self.size)
                menuScreen.scaleMode = self.scaleMode
                let trans = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(menuScreen, transition: trans)
                
            }
        }
        
        
    }
    
}
