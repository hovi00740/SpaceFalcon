//
//  GameOverScene.swift
//  Solo Mission
//
//  Created by Dwayne Anthony on 11/17/19.
//  Copyright © 2019 Dwayne Anthony. All rights reserved.
//

import Foundation
import SpriteKit


class GameOverScene: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: "DestructoBeam BB")
    
    override func didMove(to view: SKView) {
        
        let centeredMiddlePosition = CGPoint(x: self.size.width/2, y: self.size.height/2)
        let centeredTopPosition = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        let centeredLowerPosition = CGPoint(x: size.width * 0.5, y: size.height * 0.45)
        let centeredLowestPosition = CGPoint(x: size.width * 0.5, y: size.height * 0.30)
        let backgroundLayer : CGFloat = 0
        let textLayer : CGFloat = 1
        let largerFontSize : CGFloat = 70
        let MediumFontSize : CGFloat = 125/2
        let SmallFontSize : CGFloat = 90/2
        
        
        
        
        let background = SKSpriteNode(imageNamed: "SpaceBackground")
        background.position = centeredMiddlePosition
        print(centeredMiddlePosition)
        background.zPosition = backgroundLayer
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "DestructoBeam BB")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = largerFontSize
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = centeredTopPosition
        gameOverLabel.zPosition = textLayer
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "DestructoBeam BB")
        scoreLabel.text = "Score: \(gameScore) "
        scoreLabel.fontSize = MediumFontSize
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = centeredMiddlePosition
        scoreLabel.zPosition = textLayer
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if(gameScore > highScoreNumber){
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "DestructoBeam BB")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = MediumFontSize
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = centeredLowerPosition
        highScoreLabel.zPosition = textLayer
        self.addChild(highScoreLabel)
        
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = SmallFontSize
        restartLabel.fontColor = SKColor.white
        restartLabel.position = centeredLowestPosition
        restartLabel.zPosition = textLayer
        self.addChild(restartLabel)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let gameRestartTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: gameRestartTransition)
            }
        }
    }
}
