//
//  Ship.swift
//  Space Falcon
//
//  Created by Dwayne Anthony on 11/22/19.
//  Copyright © 2019 Dwayne Anthony. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

struct Ship{
    //let typeOfShip: String?
    static let LAWSOFPHYSICSFORSPACE: UInt32 = 0
    static let LAWSOFPHYSICSFORPLAYER: UInt32 = 0b1
    static let LAWSOFPHYSICSFORBULLET: UInt32 = 0b10
    static let LAWSOFPHYSICSFORENEMY: UInt32 = 0b100
    let shipLayer : CGFloat = 2
    let defaultShipScale : CGFloat = 1
    
    
    func loadPlayerShip(player: SKSpriteNode, position: CGPoint){
        setShipScalePositionAndLayer(nameOfShip: player, scale: defaultShipScale, position: position, shipLayer: shipLayer)
        defineShipsLawsOfPhysics(typeOfShip: player)
    }
    
    func createPlayerShipOrEnemyShip(typeOfShip: String, currentScene: SKScene) ->SKSpriteNode{

        
        if(typeOfShip == "player" || typeOfShip == "Player" || typeOfShip == "PLAYER"){
            let player = SKSpriteNode(imageNamed: "FalconShip")
            let centeredBelowTheScreen = CGPoint(x: currentScene.size.width/2, y: (0 - player.size.height))
            
//            player.setScale(1)
//            player.position = centeredBelowTheScreen
//            player.zPosition = shipLayer
            
            setShipScalePositionAndLayer(nameOfShip: player, scale: defaultShipScale, position: centeredBelowTheScreen, shipLayer: shipLayer)
            
            
//            player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
//            player.physicsBody!.affectedByGravity = false
//            player.physicsBody!.categoryBitMask = Ship.LAWSOFPHYSICSFORPLAYER
//            player.physicsBody!.collisionBitMask = Ship.LAWSOFPHYSICSFORSPACE
//            player.physicsBody!.contactTestBitMask = Ship.LAWSOFPHYSICSFORENEMY
            defineShipsLawsOfPhysics(typeOfShip: player)
            return player
        }
        else{
            let enemyShip = SKSpriteNode(imageNamed: "BarthShip")
            let randomXStart = random(min: currentScene.size.width * 0.2, max: currentScene.size.width * 0.8)
            //let randomXEnd = random(min: currentScene.size.width * 0.1, max: currentScene.size.width * 0.9)
            let startPoint = CGPoint(x: randomXStart , y: currentScene.size.height * 0.9)
            //let endPoint = CGPoint(x: randomXEnd, y: currentScene.size.height * 0.2)
            
            enemyShip.name = "Enemy"
            setShipScalePositionAndLayer(nameOfShip: enemyShip, scale: defaultShipScale, position: startPoint, shipLayer: shipLayer)
            enemyShip.physicsBody = SKPhysicsBody(rectangleOf: enemyShip.size)
            enemyShip.physicsBody!.affectedByGravity = false
            enemyShip.physicsBody!.categoryBitMask = Ship.LAWSOFPHYSICSFORENEMY
            enemyShip.physicsBody!.collisionBitMask = Ship.LAWSOFPHYSICSFORSPACE
            enemyShip.physicsBody!.contactTestBitMask = Ship.LAWSOFPHYSICSFORPLAYER | Ship.LAWSOFPHYSICSFORBULLET
//            defineShipsLawsOfPhysics(typeOfShip: enemyShip)
            return enemyShip
        }
    }
    func setShipScalePositionAndLayer(nameOfShip: SKSpriteNode,scale: CGFloat, position: CGPoint, shipLayer: CGFloat){
        nameOfShip.setScale(scale)
        nameOfShip.position = position
        nameOfShip.zPosition = shipLayer
    }
    func defineShipsLawsOfPhysics(typeOfShip: SKSpriteNode) -> SKSpriteNode{
        if(typeOfShip.name == "Player"){
            typeOfShip.physicsBody!.categoryBitMask = Ship.LAWSOFPHYSICSFORPLAYER
            typeOfShip.physicsBody!.contactTestBitMask = Ship.LAWSOFPHYSICSFORENEMY
        }
        else{
            if(typeOfShip.physicsBody != nil){
            typeOfShip.physicsBody!.categoryBitMask = Ship.LAWSOFPHYSICSFORENEMY
            typeOfShip.physicsBody!.contactTestBitMask = Ship.LAWSOFPHYSICSFORPLAYER | Ship.LAWSOFPHYSICSFORBULLET
            }
        }
        
        typeOfShip.physicsBody = SKPhysicsBody(rectangleOf: typeOfShip.size)
        typeOfShip.physicsBody!.affectedByGravity = false
        typeOfShip.physicsBody!.collisionBitMask = Ship.LAWSOFPHYSICSFORSPACE
        return typeOfShip
    }
    func moveEnemyShip(endPoint: CGPoint, currentScene: SKScene) -> SKAction{

        //endPoint = generateEnemyPlayerEndPoint(currentScene: currentScene)
        return SKAction.move(to: endPoint, duration: 1)
    }
    func rotateEnemyShip(endPoint: CGPoint, enemyShip: SKSpriteNode){
                let distanceBetweenStartAndEndX = endPoint.x - enemyShip.position.x//startPoint.x
                let distanceBetweenStartAndEndY = endPoint.y - enemyShip.position.y
                let amountToRotate = atan2(distanceBetweenStartAndEndY, distanceBetweenStartAndEndX)
                enemyShip.zRotation = amountToRotate
    }
    func generateEnemyPlayerEndPoint(currentScene: SKScene) -> CGPoint{
        let randomXEnd = random(min: currentScene.size.width * 0.1, max: currentScene.size.width * 0.9)
        let endPoint = CGPoint(x: randomXEnd, y: currentScene.size.height * 0.2)
        
        return endPoint
    }
    func deleteEnemyShip() -> SKAction{
        return SKAction.removeFromParent()
    }
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
}
