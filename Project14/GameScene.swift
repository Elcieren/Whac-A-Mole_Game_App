//
//  GameScene.swift
//  Project14
//
//  Created by Eren Elçi on 26.10.2024.
//

import SpriteKit


class GameScene: SKScene {
    //Oyuncunun puanını gösteren bir SKLabelNode etiketi.
    var gameScore: SKLabelNode!
    //WhackSlot nesnelerinden oluşan bir dizi.
    var slots =  [WhackSlot]()
    //Düşmanların görünme hızını kontrol eden bir değişken
    var popupTime = 2.0
    var numRounds = 0
    
    
    var score = 0 {
        didSet {
            if let scoreLabel = gameScore {
                scoreLabel.text = "Score: \(score)"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        starGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            print("Tapped node: \(node.name ?? "unknown")")
            if node.name == "again" {
            starGame()
            return
          }
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible  { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            if node.name == "charFriend" {
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            }
        }
        
        
    }
    
    func creatSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
        
    }
    
    func creatEnemy(){
        numRounds += 1
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            gameOver.name = "game"
            addChild(gameOver)
            
            let again = SKSpriteNode(imageNamed: "agains") // "again" düğmesinin adı doğru olmalı
            again.position = CGPoint(x: 500, y: 250)
            again.zPosition = 1
            again.name = "again"
            addChild(again)
            return
            
        }
        popupTime *= 0.95
        slots.shuffle()
        let hideTime = popupTime * 1.5
        slots[0].show(hideTime: hideTime)
        
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: hideTime)}
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: hideTime)}
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: hideTime)}
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: hideTime)}
        
        let minDelay = popupTime * 0.5 
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay ) { [weak self] in
            self?.creatEnemy()
        }
    }
    
    func starGame(){
        removeAllChildren()
        score = 0
        numRounds = 0
        popupTime = 1.5

        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)

        for i in 0..<5 {
            creatSlot(at: CGPoint(x: 100 + (i * 170), y: 410))
        }
        for i in 0..<4 {
            creatSlot(at: CGPoint(x: 180 + (i * 170), y: 320))
        }
        for i in 0..<5 {
            creatSlot(at: CGPoint(x: 100 + (i * 170), y: 230))
        }
        for i in 0..<4 {
            creatSlot(at: CGPoint(x: 180 + (i * 170), y: 140))
        }

        // Oyunu başlat
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.creatEnemy()
        }
    }

}
