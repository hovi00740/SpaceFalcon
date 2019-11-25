//
//  PlayerShip.swift
//  Space Falcon
//
//  Created by Dwayne Anthony on 11/22/19.
//  Copyright © 2019 Dwayne Anthony. All rights reserved.
//

import Foundation
import UIKit
import GameKit

struct PlayerShip{
    let player = SKSpriteNode(imageNamed: "FalconShip")
    let shipLayer : CGFloat = 2
    
    func loadPlayerShip(currentScreen: SKScene){
        let centeredBelowTheScreen = CGPoint(x: currentScreen.size.width/2, y: (0 - player.size.height))
        player.setScale(1)
        player.position = centeredBelowTheScreen
        player.zPosition = CGFloat(2)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = LawsOfPhysics.FORTHEPLAYER//PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = LawsOfPhysics.FORTHEUNIVERSE//PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = LawsOfPhysics.FORTHEENEMY
    }

    
}
