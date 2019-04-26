//
//  GameScene.swift
//  space hero
//
//  Created by Shao-Chiang Tsai on 4/9/17.
//  Copyright © 2017 Shao-Chiang Tsai. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion


var score = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "playerShip")
    let bulletSound = SKAction.playSoundFileNamed("PhotonShot.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("Explosion.wav", waitForCompletion: false)
    let EbulletSound = SKAction.playSoundFileNamed("EPhotonShot.wav", waitForCompletion: false)
    let PhysicsType = PhysicsTypes()
    var scoreLabel = SKLabelNode()
    var playerHealth = 4
    var playerHealthLabel = SKLabelNode()
    var ultLabel = SKLabelNode()
    var ultNum = 3
    var gameOverFlag = false
    //sctsai
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    var yAcceleration:CGFloat = 0
    var gameBackGroundMusic: SKAudioNode!
    
    
    let gameArea: CGRect
    override init(size: CGSize){
        let ratioMax: CGFloat = 1.778
        let screenWidth = size.height / ratioMax
        let margin = (size.width - screenWidth)/2.0
        gameArea = CGRect(x: margin, y: 0, width: screenWidth, height: size.height)
            
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    private func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    override func didMove(to view: SKView) {
        score = 0
        self.physicsWorld.contactDelegate = self
        
        for i in 0...10{
            let background = SKSpriteNode(imageNamed: "background") //changed
            background.size = self.size
            background.anchorPoint = CGPoint(x:0.5, y: 0)
            background.name="Bg"
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            self.addChild(background)
        }
        
        player.setScale(1)
        //player.position = CGPoint(x: self.size.width/2, y: self.size.height*0.05)
        player.zPosition = 2
        
        //sctsai
        player.position = CGPoint(x: self.frame.size.width/2, y: player.size.height/2+20)
        self.physicsWorld.gravity = CGVector(dx:0, dy:0)
        self.physicsWorld.contactDelegate = self
        
        player.physicsBody = SKPhysicsBody(rectangleOf:player.size)
        //player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsType.Player
        player.physicsBody!.collisionBitMask = PhysicsType.None
        player.physicsBody!.contactTestBitMask = PhysicsType.Enemy
        self.addChild(player)
        
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontName = "E-SQUARE"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x:self.size.width*0.15, y:self.size.height*0.95)
        scoreLabel.zPosition = 50
        self.addChild(scoreLabel)
        
        playerHealthLabel.text = "HP: 4"
        playerHealthLabel.fontName = "E-SQUARE"
        playerHealthLabel.fontSize = 60
        playerHealthLabel.fontColor = SKColor.white
        playerHealthLabel.zPosition = 50
        playerHealthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        playerHealthLabel.position = CGPoint(x:self.size.width*0.85, y:self.size.height*0.95)
        self.addChild(playerHealthLabel)
        
        ultLabel.text = "❄"
        ultLabel.fontSize = 70
        ultLabel.fontColor = SKColor.white
        ultLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        ultLabel.position = CGPoint(x:self.size.width*0.13, y:self.size.height*0.01)
        ultLabel.zPosition = 50
        self.addChild(ultLabel)
        
        startNewLevel(levelNum: 1)
        //sctsai
        motionManger.accelerometerUpdateInterval = 0.1
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) {(data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
                self.yAcceleration = CGFloat(acceleration.y) * 0.75 + self.yAcceleration * 0.25
            }
        }
        
    }
    
    //moving background
    var lastFrameTime: TimeInterval = 0
    var passedTime: TimeInterval = 0
    var moveSpeed : CGFloat = 500.0
    override func update(_ current:TimeInterval){
        if (lastFrameTime == 0){
            lastFrameTime = current
        }else{
            passedTime = current - lastFrameTime
            lastFrameTime = current
        }
        let backgroundMove = moveSpeed * CGFloat(passedTime)
        self.enumerateChildNodes(withName: "Bg"){
            (background, stop) in
            background.position.y -= backgroundMove
            if (background.position.y < -self.size.height){
                background.position.y += self.size.height*2
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var physicBody = SKPhysicsBody()
        var physicBody2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            physicBody = contact.bodyA
            physicBody2 = contact.bodyB
        }else{
            physicBody = contact.bodyB
            physicBody2 = contact.bodyA
        }
        if physicBody.categoryBitMask == PhysicsType.Player && physicBody2.categoryBitMask == PhysicsType.Enemy{
            loseHP()
            if (physicBody.node != nil && playerHealth <= 0){
                explosion(explosionPosition: physicBody.node!.position)
                physicBody.node?.removeFromParent()
            }
            if (physicBody2.node != nil){
                explosion(explosionPosition: physicBody2.node!.position)
                physicBody2.node?.removeFromParent()
            }
        }
        if physicBody.categoryBitMask == PhysicsType.Bullet && physicBody2.categoryBitMask == PhysicsType.Enemy{
            if (physicBody2.node != nil){
                explosion(explosionPosition: physicBody2.node!.position)
            }
            cumulateScore()
            physicBody.node?.removeFromParent()
            physicBody2.node?.removeFromParent()
        }

    }
    
    private func cumulateScore(){
        score += 3
        scoreLabel.text = "SCORE: \(score)"
        //recharge ult by 2 if player reaches score:18
        if (score == 18){
            startNewLevel(levelNum: 2)
            if (ultNum == 0){
                self.addChild(ultLabel)
            }
            ultNum += 2
        }
        //recharge ult by 2 if player reaches score:60
        if (score == 60){
            startNewLevel(levelNum: 3)
            if(ultNum == 0){
                self.addChild(ultLabel)
            }
            ultNum += 2
        }
    }
    
    private func loseHP(){
        playerHealth -= 1
        playerHealthLabel.text = "HP: \(playerHealth)"
        if (playerHealth == 1){
            playerHealthLabel.fontColor = SKColor.red
            playerHealthLabel.fontSize = 80
        }
        if (playerHealth == 0){
            gameOver()
        }
    }
    
    private func gameOver(){
        gameOverFlag = true
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bul"){
            (bullet, stop) in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Bul2"){
            (bullet2, stop) in
            bullet2.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Bomb"){
            (bomber, stop) in
            bomber.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Fight"){
            (enemy, stop) in
            enemy.removeAllActions()
        }
        let endGame = SKAction.run(changeScreen)
        let wait20 = SKAction.wait(forDuration: 1.5)
        let sequence = SKAction.sequence([wait20, endGame])
        self.run(sequence)
    }
    
    func changeScreen(){
        let gameEndScreen = gameEnd(size:self.size)
        gameEndScreen.scaleMode = self.scaleMode
        let trans = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(gameEndScreen, transition: trans)
        
    }
    
    
    
    private func fireBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet") //changed
        bullet.name = "Bul"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf:bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsType.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsType.None
        bullet.physicsBody!.contactTestBitMask = PhysicsType.Player | PhysicsType.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
        
    }
    
    private func explosion(explosionPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed:"boom")
        explosion.position = explosionPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        let displayExplosion = SKAction.scale(to: 1, duration: 0.2)
        let removeExplosion = SKAction.fadeOut(withDuration: 0.2)
        let deleteExplosion = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([explosionSound, displayExplosion, removeExplosion, deleteExplosion])
        explosion.run(explosionSequence)
    }
    
    
    private func createFighter() {
        
        let enemyXStart = random(min: gameArea.minX, max: gameArea.maxX)
        //let enemyXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        let enemyXEnd = player.position.x
        
        let startPosition = CGPoint(x: enemyXStart, y: self.size.height * 1.25)
        let endPosition = CGPoint(x: enemyXEnd, y: -self.size.height * 0.25)
        let enemy = SKSpriteNode(imageNamed: "fighter")
        enemy.name = "Fight"
        enemy.setScale(1)
        enemy.position = startPosition
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf:enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsType.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsType.None
        enemy.physicsBody!.contactTestBitMask = PhysicsType.Player | PhysicsType.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        enemy.run(enemySequence)
        
        let dX = endPosition.x - startPosition.x
        let dY = endPosition.y - startPosition.y
        let amountToRotate = atan2(dY,dX)
        enemy.zRotation = amountToRotate-1.5708
        
    }
    
    private func createBomber() {
        
        
        let enemyXStart = random(min: gameArea.minX+50, max: gameArea.maxX-50)
        let enemyXEnd = enemyXStart
        
        let startPosition = CGPoint(x: enemyXStart, y: self.size.height * 1.25)
        let endPosition = CGPoint(x: enemyXEnd, y: -self.size.height * 0.25)
        let bomber = SKSpriteNode(imageNamed: "bomber")
        bomber.name = "Bomb"
        bomber.setScale(1)
        bomber.position = startPosition
        bomber.zPosition = 2
        bomber.physicsBody = SKPhysicsBody(rectangleOf:bomber.size)
        bomber.physicsBody!.affectedByGravity = false
        bomber.physicsBody!.categoryBitMask = PhysicsType.Enemy
        bomber.physicsBody!.collisionBitMask = PhysicsType.None
        bomber.physicsBody!.contactTestBitMask = PhysicsType.Player | PhysicsType.Bullet
        self.addChild(bomber)
        let moveEnemy = SKAction.move(to: endPosition, duration: 5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        bomber.run(enemySequence)
        
        let dX = endPosition.x - startPosition.x
        let dY = endPosition.y - startPosition.y
        let amountToRotate = atan2(dY,dX)
        bomber.zRotation = amountToRotate-1.5708
        //print(amountToRotate)
        
        let bullet2 = SKSpriteNode(imageNamed: "Ebullet")
        bullet2.name = "Bul2"
        bullet2.setScale(1)
        bullet2.position = bomber.physicsBody!.node!.position
        bullet2.zPosition = 1
        bullet2.physicsBody = SKPhysicsBody(rectangleOf:bullet2.size)
        bullet2.physicsBody!.affectedByGravity = false
        bullet2.physicsBody!.categoryBitMask = PhysicsType.Enemy
        bullet2.physicsBody!.collisionBitMask = PhysicsType.None
        bullet2.physicsBody!.contactTestBitMask = PhysicsType.Player | PhysicsType.Enemy
        self.addChild(bullet2)
        let moveBullet = SKAction.move(to:endPosition, duration: 3)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([EbulletSound, moveBullet, deleteBullet])
        bullet2.run(bulletSequence)
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (gameOverFlag == false){
            fireBullet()
        }
        //ULT action
        for touch: AnyObject in touches{
            let touchLocation = touch.location(in: self)
            
            if  (ultLabel.contains(touchLocation) && ultNum > 0){
                ultNum -= 1
                if (ultNum == 0){
                    ultLabel.removeFromParent()
                }
                self.enumerateChildNodes(withName: "Bomb"){
                    (bomber, stop) in
                    bomber.removeAllActions()
                }
                self.enumerateChildNodes(withName: "Fight"){
                    (enemy, stop) in
                    enemy.removeAllActions()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            player.position.x += amountDragged
            
            let shipWidth = player.size.width
            if player.position.x > (gameArea.maxX-shipWidth/2){
                player.position.x = (gameArea.maxX-shipWidth/2)
            }
            
            if player.position.x < (gameArea.minX+shipWidth/2){
                player.position.x = (gameArea.minX+shipWidth/2)
            }
            
        }
        
    }
    //speed up when player reaches a certain score
    private func startNewLevel(levelNum:Int){
        if self.action(forKey: "spawn") != nil{
            self.removeAction(forKey: "spawn")
        }
        var diff = TimeInterval()
        switch levelNum{
        case 1:  diff = 2
        case 2:  diff = 1
        case 3:  diff = 0.2
        default: diff = 2
            
        }
        let spawnBomber = SKAction.run(createBomber)
        let spawnFighter = SKAction.run(createFighter)
        let wait03 = SKAction.wait(forDuration: 0.3)
        let wait10 = SKAction.wait(forDuration: diff)
        let spawnSequence = SKAction.sequence([spawnBomber, wait03, spawnBomber, wait03, spawnBomber, wait10, spawnFighter, wait10])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawn")
        
    }
    //player moving by gravity
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 100
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        } else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
        player.position.y += yAcceleration * 100
        if player.position.y < 0 {
            player.position = CGPoint(x: player.position.x, y: 0)
        } else if player.position.y > self.size.height {
            player.position = CGPoint(x: player.position.x, y: self.size.height)
        }

    }
}
