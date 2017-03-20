//
//  MoreGame.swift
//  Football
//
//  Created by Ting on 2015/10/24.
//  Copyright © 2015年 Ting. All rights reserved.
//

import SpriteKit
import AVFoundation

class MoreGame: SKScene {
    
    var crab1:SKSpriteNode!
    var crab2:SKSpriteNode!
    var ship:SKSpriteNode!
    var coverShip:SKSpriteNode!
    var coverShip2:SKSpriteNode!
    var dog1:SKSpriteNode!

    var isOver = false
    var gameOverImage: SKSpriteNode!
    var buttonPressedSound = SKAction.playSoundFileNamed("ButtonPressed.mp3", waitForCompletion: false)
    var hitSound = SKAction.playSoundFileNamed("Hit.mp3", waitForCompletion: false)
    var overSound = SKAction.playSoundFileNamed("GameOver.mp3", waitForCompletion: false)
    var backButton:SpriteKitButton!
    
    var myAudio:AVAudioPlayer!
    var seaAudio:AVAudioPlayer!
    
    var ship1:SKSpriteNode!
    
    var balloon1:SKSpriteNode!
    var balloonSelected = "no"
    
    override func didMove(to view: SKView) {
        
        crab1 = childNode(withName: "crab1") as! SKSpriteNode //拿到螃蟹1
        crab2 = childNode(withName: "crab2") as! SKSpriteNode //拿到螃蟹2
//        square = childNodeWithName("square") as! SKSpriteNode //拿到要移動的指定物體（例:熱氣球)
        balloon1 = childNode(withName: "balloon1") as! SKSpriteNode //拿到熱氣球
        
        dog1 = childNode(withName: "dog1") as! SKSpriteNode
        
        ship1 = SKSpriteNode(imageNamed: "ship1")
        ship1.position = CGPoint(x:2000, y:850)
        ship1.size = CGSize(width: 550, height: 250)
        self.addChild(ship1)
        
        //製作返回按鈕
        backButton = SpriteKitButton(defaultButtonImage: "backNotice",
            activeButtonImage:"backNotice", buttonAction: backToMenu)
        backButton.position = CGPoint(x:360, y: 160)
        self.addChild(backButton)

        
        //製作提醒視窗
        let alert = UIAlertView(title: "【心情不佳，必看海景！】",
            message: "請靜下心來一分鐘！ \n 聆聽浪濤聲，下一秒，心情會更好! \n ======================== \n 準備好仰望天空，沈澱心靈了嗎？",
            delegate: nil,
            cancelButtonTitle: "OK!")
        alert.show()
        
        //產生AVaudioPlayer來播放海浪聲
        do{
            try seaAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "summer_beach", ofType: "mp3")!))
        }catch {
            print("sea music fail")
        }
        seaAudio.volume = 0.7  //調整音量
        seaAudio.numberOfLoops = -1  //重複循環播放
        seaAudio.play()
        
        
        //製作遊艇的動畫
        let shipMove = SKAction.rotate(byAngle: -2.0 * CGFloat(M_PI)/180.0, duration: 1.0) //在1秒內旋轉2度（要轉換成鏡度）
        let shipBack = SKAction.rotate(byAngle: 2.0 * CGFloat(M_PI)/180.0, duration: 1.0) //在1秒內轉回來-2度的動作
        let shipMoveAndBack = SKAction.sequence([shipMove,shipBack])//執行旋轉的動作
        let repeatRotation = SKAction.repeatForever(shipMoveAndBack)
        
        let covership = childNode(withName: "coverShip") as! SKSpriteNode
        covership.run(repeatRotation)
        
        
        //製作小狗的動畫
        let dogMove = SKAction.rotate(byAngle: 3.5 * CGFloat(M_PI)/180.0, duration: 2.0) //在1秒內旋轉2.5度（要轉換成鏡度）
        let dogBack = SKAction.rotate(byAngle: -3.5 * CGFloat(M_PI)/180.0, duration: 2.0) //在1秒內轉回來2.5度的動作
        let dogMoveAndBack = SKAction.sequence([dogMove,dogBack])//執行旋轉的動作
        let repeatDogRotation = SKAction.repeatForever(dogMoveAndBack)
        
        let coverdog = childNode(withName: "dog1") as! SKSpriteNode
        _ = SKAction.playSoundFileNamed("DogBark.wav", waitForCompletion: true) //碰到按鈕時，發出聲音
        coverdog.run(repeatDogRotation)
    }
    
    
    //移動熱氣球的方法
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isOver == false {
            
            let touch = touches.first as UITouch!
            let positionInScene = touch?.location(in: self)     //將找到觸碰的位置，存入positionInScene變數中
            let touchedNode = self.atPoint(positionInScene!)  //碰到第幾個拼圖就存第幾個批圖，存入touchedNode
            balloonSelected = touchedNode.name! //將碰到的圖的名稱存入puzzleSelected  //因為不確定每個圖片都有name，所以加！告知程式每個圖一定都有名稱
            if balloonSelected.hasPrefix("balloon1"){
                let touchedNode = childNode(withName: balloonSelected) as! SKSpriteNode
                touchedNode.position.x = (positionInScene?.x)!
                touchedNode.position.y = (positionInScene?.y)!
            }
        }
    }
    
    
    //移動熱氣球
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first as UITouch! //找到觸碰事件
        let positionInScene = touch?.location(in: self)  //將找到觸碰的位置，存入positionInScene變數中
        
        if balloonSelected.hasPrefix("balloon1") {  //有balloon這個字的圖才可以移動（避免移動到背景圖）
            let touchedNode = childNode(withName: balloonSelected) as! SKSpriteNode  //碰到地幾個拼圖就存地幾個批圖，存入touchedNode
            touchedNode.position.x = (positionInScene?.x)!  //觸碰到的拼圖的x座標就存入觸碰點的x座標
            touchedNode.position.y = (positionInScene?.y)!  //觸碰到的拼圖的y座標就存入觸碰點的y座標
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
//        dog.position.x = dog.position.x + -7.0
        ship1.position.x = ship1.position.x + -1.0
    }
    
    
    func backToMenu(){
        if let scene = GameScene(fileNamed: "GameScene") {
            
            scene.scaleMode = .aspectFill
            let myTransition = SKTransition.push(with: .right, duration: 0.5)
            view?.presentScene(scene, transition: myTransition)
            
            seaAudio.stop()
        }
    }

}
