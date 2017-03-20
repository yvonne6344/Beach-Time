//
//  GamePlay.swift
//  Football
//
//  Created by Ting on 2015/10/20.
//  Copyright © 2015年 Ting. All rights reserved.
//

import SpriteKit
import AVFoundation

class GamePlay: SKScene {
 
    var ball:SKSpriteNode!
    var ground:SKSpriteNode!
    var isOver = false
    var gameOverImage: SKSpriteNode!

    var buttonPressedSound = SKAction.playSoundFileNamed("ButtonPressed.mp3", waitForCompletion: false)
    var hitSound = SKAction.playSoundFileNamed("Hit.mp3", waitForCompletion: false)
    var overSound = SKAction.playSoundFileNamed("GameOver.mp3", waitForCompletion: false)
    var backButton:SpriteKitButton!
    var scoreLabel:SKLabelNode!
    var score:Int = 0
    var highscore:Int = 0
    
    var myAudio:AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        
        ball = childNode(withName: "ball") as! SKSpriteNode //拿到球
        ground = childNode(withName: "ground") as! SKSpriteNode //拿到地板
        ground.color = UIColor.clear
        gameOverImage = childNode(withName: "gameOverImage") as! SKSpriteNode //拿到gameOver的圖
        gameOverImage.isHidden = true
        
        backButton = SpriteKitButton(defaultButtonImage: "BackWebButton",
            activeButtonImage:"BackWebButtonPressed", buttonAction: backToMenu)
        backButton.position = CGPoint(x:768, y: 407)
        backButton.isHidden = true
        self.addChild(backButton)
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode //用scoreLabel來改變分數
        scoreLabel.fontName = "Marker Felt"
        scoreLabel.text = "Score: \(score)"
        
        if let highscoreString = UserDefaults.standard.object(forKey: "highscore") as? String {
            
            if let unwrappedNumber = Int(highscoreString) {
                
                highscore = unwrappedNumber
                scoreLabel.text = "Highscore: \(highscore)"
            }
        }
        
        //產生一個AVAudioPlayer來播放托球聲
        do{
            try myAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "VolleyballBGM", ofType: "mp3")!))
            
        }catch {
            print("Fail")
        }
        myAudio.numberOfLoops = -1
        myAudio.play()
        
        
        //製作GameOver動畫
        gameOverImage = SKSpriteNode(imageNamed: "GameOver")
        gameOverImage.position = CGPoint(x:1500, y:1600)
        gameOverImage.size = CGSize(width: 1000, height: 400)
        self.addChild(gameOverImage)
        gameOverImage.isHidden = true
    }
    
    func backToMenu(){
        if let scene = GameScene(fileNamed: "GameScene") {
            
            scene.scaleMode = .aspectFill
            let myTransition = SKTransition.push(with: .right, duration: 0.5)
            view?.presentScene(scene, transition: myTransition)
        }
        myAudio.stop()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first?.location(in: self)
        let nodeTouched = atPoint(location!)
        if isOver == false{
        if nodeTouched.name == "ball" {
            
            print("you touched me!")
            ball.physicsBody?.applyImpulse(CGVector(dx: (ball.position.x - location!.x) * 20, dy: 8500))
            
            run(hitSound)
            score += 1
            scoreLabel.text = "Score: \(score)"
            }
        }else {
        //在遊戲尚未結束時，就做之前的程式碼動作，結束時，就執行重新遊戲的程式碼
            isOver = false
            ball.position = CGPoint(x:370, y:770)
            ball.zRotation = 0
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.angularVelocity = 0
            ball.isHidden = false
            gameOverImage.isHidden = true
            run(buttonPressedSound)
            backButton.isHidden = true
            score = 0
            scoreLabel.text = "Score: \(score)"
            self.physicsWorld.speed = 1
        }  
        
    }
    
    override func didEvaluateActions() {
        if ball.frame.intersects(ground.frame) {
            print("hit it")
            self.physicsWorld.speed = 0
            self.gameOver()
            }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        //        dog.position.x = dog.position.x + -7.0
        gameOverImage.position.x = gameOverImage.position.x + -3.0
    }
    
    
    func gameOver() {
        
        if isOver == false {
            run(overSound)
            isOver = true
            
            if score > highscore {
                
                highscore = score
                UserDefaults.standard.set("\(score)", forKey: "highscore")
                scoreLabel.text = "HIGHSCORE!!"
            }
        }
        ball.isHidden = true
        gameOverImage.isHidden = false
        backButton.isHidden = false
    }

}
