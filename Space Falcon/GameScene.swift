//
//  GameScene.swift
//  Space Falcon
//
//  Created by Dwayne Anthony on 11/16/19.
//  Copyright © 2019 Dwayne Anthony. All rights reserved.
//  Fuck AVANADE

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var shipFactory = Ship()
    var lawsOfTheGame = LawsOfPhysics()
    let player = PlayerShip()//SKSpriteNode(imageNamed: "FalconShip")
    let archorPoint = CGPoint(x: 0, y: 0)
    var levelNumber = 1
    var numberOfLives = 3
    let numberOfLivesLabel = SKLabelNode(fontNamed: "DestructoBeam BB")
    let largeFontSize : CGFloat = 60
    let mediumFontSize : CGFloat = 45
    let shipLayer : CGFloat = 2
    let defaultLayer : CGFloat = 1
    let backgroundLayer : CGFloat = 0
    let playerInfoLayer: CGFloat = 100
    let scoreLabel = SKLabelNode(fontNamed: "DestructoBeam BB")
    let tapToStartLabel = SKLabelNode(fontNamed: "DestructoBeam BB")
    enum gameState{
        case preGame
        case inGame
        case afterGame
    }
    
    var currentGameState = gameState.preGame

    override func didMove(to view: SKView) {
        gameScore = 0
        self.physicsWorld.contactDelegate = self
        let centeredBelowTheScreen = CGPoint(x: self.size.width/2, y: (0 - player.player.size.height))
        //let pointHorizontalCenteredBottom = CGPoint(x: self.size.width/2, y: (self.size.height * 0.1))
        let centeredPoint = CGPoint(x: size.width/2, y: size.height/2)
        //let topLeftCorner = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.9)
        //let topRightCorner = CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.9)
        //let outsideTopOfTheScreen = CGPoint(x: 0, y: self.size.height + scoreLabel.frame.size.height * 1.2)
        let scoreLabelOffTheScreen = CGPoint(x: self.size.width * 0.15, y: self.size.height + scoreLabel.frame.size.height)
        let numberOfLivesLabelOffTheScreen = CGPoint(x: self.size.width * 0.85, y: self.size.height + numberOfLivesLabel.frame.size.height)
        let topOfTheScreen = CGFloat(self.size.height * 0.9)
        let textInvisible : CGFloat = 0
        //let textVisible : CGFloat = 1

        
        for frame in 0...1{
            let background = SKSpriteNode(imageNamed: "SpaceBackground")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(frame))
            background.zPosition = backgroundLayer
            background.name = "Background"
            self.addChild(background)
        }

        player.loadPlayerShip(currentScreen: self)
        self.addChild(player.player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = mediumFontSize
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = scoreLabelOffTheScreen
        scoreLabel.zPosition = playerInfoLayer
        self.addChild(scoreLabel)
        
        numberOfLivesLabel.text = "Lives: 3"
        numberOfLivesLabel.fontSize = mediumFontSize
        numberOfLivesLabel.fontColor = SKColor.white
        numberOfLivesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        numberOfLivesLabel.position = numberOfLivesLabelOffTheScreen
        numberOfLivesLabel.zPosition = playerInfoLayer
        self.addChild(numberOfLivesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: topOfTheScreen, duration: 0.5)
        scoreLabel.run(moveOnToScreenAction)
        numberOfLivesLabel.run(moveOnToScreenAction)
        
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = largeFontSize
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = defaultLayer
        tapToStartLabel.position = centeredPoint
        tapToStartLabel.alpha = textInvisible
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 1)
        tapToStartLabel.run(fadeInAction)
        startNewLevel()
    }
    
    var lastUpdateTime : TimeInterval = 0
    var changeInTimeFrame : TimeInterval = 0
    var amountToMovePerSecond : CGFloat = 600.0
    
    override func update(_ currentTime: TimeInterval){
        if (lastUpdateTime == 0){
            lastUpdateTime = currentTime
        }
        else {
            changeInTimeFrame = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(changeInTimeFrame)
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            
            if(self.currentGameState == gameState.inGame){
                background.position.y -= amountToMoveBackground
            }
            if(background.position.y < -self.size.height){
                background.position.y += self.size.height*2
            }
        }
        
        
    }
    
    func startGame(){
        currentGameState = gameState.inGame
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction,deleteAction])
        tapToStartLabel.run(deleteSequence)
        let movePlayerShipOntoScreenAction = SKAction.moveTo(y: self.size.height * 0.1, duration: 1)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([movePlayerShipOntoScreenAction, startLevelAction])
        player.player.run(startGameSequence)
    }
    
    func loseALife(){
        numberOfLives -= 1
        numberOfLivesLabel.text = "Lives: \(numberOfLives)"
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1, duration: 0.1)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        numberOfLivesLabel.run(scaleSequence)
        if(numberOfLives == 0){
            runGameOver()
        }
    }
    
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1, duration: 0.1)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        scalingAnimation(scaleSize: 1.5, duration: 0.1)
        scoreLabel.run(scaleSequence)
        if gameScore == 5 || gameScore == 10 || gameScore == 20 || gameScore == 40 || gameScore == 80{
            startNewLevel()
        }
    }
    func scalingAnimation(scaleSize: CGFloat, duration: TimeInterval) -> SKAction{
        let scaleUp = SKAction.scale(to: scaleSize, duration: duration)
        let scaleDown = SKAction.scale(to: scaleSize, duration: duration)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        return scaleSequence
    }
    
    func runGameOver(){
        currentGameState = .afterGame
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy"){
            Enemy, stop in
            Enemy.removeAllActions()
        }
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene,changeSceneAction])
        self.run(changeSceneSequence)
    }
    
        func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        print("Scale is: \(sceneToMoveTo.scaleMode)")
        let gameOverTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: gameOverTransition)
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1  = contact.bodyA
            body2  = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == LawsOfPhysics.FORTHEPLAYER && body2.categoryBitMask == LawsOfPhysics.FORTHEENEMY{
            
            if(body1.node != nil){
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            if(body2.node != nil){
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            runGameOver()
        }
        if body1.categoryBitMask == LawsOfPhysics.FORTHEBULLET && body2.categoryBitMask == LawsOfPhysics.FORTHEENEMY{
            addScore()
            if(body2.node != nil){
                if(body2.node!.position.y > self.size.height){
                    return
                }
                else{
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "boom")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        let scaleIn = SKAction.scale(to: 2, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([scaleIn,fadeOut,delete])
        explosion.run(explosionSequence)
    }
    
    func startNewLevel(){
        levelNumber += 1
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        var levelDuration = TimeInterval()
        switch levelNumber {
        case 1:
            levelDuration = 4
        case 2:
            levelDuration = 3
        case 3:
            levelDuration = 2
        case 4:
            levelDuration = 1.5
        case 5:
            levelDuration = 1
        case 6:
            levelDuration = 0.8
            
        default:
            levelDuration = 0.5
            print("Cant find level number")
        }
        let spawn = SKAction.run(spwanEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        if (currentGameState == gameState.inGame){
            self.run(spawnForever, withKey: "spawningEnemies")
        }
    }
    
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "Bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = LawsOfPhysics.FORTHEBULLET
        bullet.physicsBody!.collisionBitMask = LawsOfPhysics.FORTHEUNIVERSE
        bullet.physicsBody!.contactTestBitMask = LawsOfPhysics.FORTHEENEMY
        self.addChild(bullet)
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    func spwanEnemy(){
        let enemyShip = shipFactory.createPlayerShipOrEnemyShip(typeOfShip: "Enemy", currentScene: self)
        self.addChild(enemyShip)
        let enemyEndPoint = shipFactory.generateEnemyPlayerEndPoint(currentScene: self)
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([shipFactory.moveEnemyShip(endPoint: enemyEndPoint,currentScene: self), shipFactory.deleteEnemyShip(), loseALifeAction])
        if(currentGameState == gameState.inGame){
            enemyShip.run(enemySequence)
        }
        shipFactory.rotateEnemyShip(endPoint: enemyEndPoint, enemyShip: enemyShip)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(currentGameState == gameState.preGame){
            startGame()
        }
        else if(currentGameState == gameState.inGame){
            fireBullet()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            if currentGameState == gameState.inGame{
                player.player.position.x += amountDragged
            }
            keepPlayerWithinBoundaries()
        }
    }
    func keepPlayerWithinBoundaries(){
        let leftScreenBoundary : CGFloat = (self.size.width * 0.1 - player.player.size.width/2)
        let rightScreenBoundary : CGFloat = (self.size.width * 0.9 - player.player.size.width/2)
        if(player.player.position.x > rightScreenBoundary){
            player.player.position.x = rightScreenBoundary
        }
        if(player.player.position.x < leftScreenBoundary){
            player.player.position.x = leftScreenBoundary
        }
    }
    
}
