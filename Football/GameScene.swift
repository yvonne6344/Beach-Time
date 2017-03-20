//
//  GameScene.swift
//  Football
//
//  Created by Ting on 2015/10/20.
//  Copyright (c) 2015年 Ting. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var coverBall:SKSpriteNode!
    var myAudio:AVAudioPlayer!
    var seaAudio:AVAudioPlayer!
    
    
    override func didMove(to view: SKView) {
        
        //在主畫面中製作三顆按鈕
        let playButton = SpriteKitButton(defaultButtonImage: "PlayButton", activeButtonImage: "PlayButtonPressed", buttonAction: playTheGame)
        playButton.position = CGPoint(x: size.width/2, y: 1320)
        addChild(playButton)
        
        let relaxButton = SpriteKitButton(defaultButtonImage: "RelaxButton", activeButtonImage: "RelaxButtonPressed", buttonAction: moreGame)
        relaxButton.position = CGPoint(x: size.width/2, y: 1020)
        addChild(relaxButton)
        
        let aboutGameButton = SpriteKitButton(defaultButtonImage: "AboutGameButton", activeButtonImage: "AboutGameButtonPressed", buttonAction: aboutTheGame)
        aboutGameButton.position = CGPoint(x: size.width/2, y: 720)
        addChild(aboutGameButton)
        
        
        //製作PlayButton的動畫
        let scaleUp = SKAction.scale(to: 1.05,duration: 0.1) //在0.1秒內放大1.05倍
        let scaleDown = SKAction.scale(to: 1, duration: 0.3) //在0.3秒內縮小至原來大小
        let scaleUpAndDown = SKAction.sequence([scaleUp,scaleDown]) //先放大再縮小
        let repeatAction = SKAction.repeatForever(scaleUpAndDown) //重複執行放大縮小的動作
        playButton.run(repeatAction) //執行放大縮小
        
        
        //製作橄欖球的動畫
        let rotate = SKAction.rotate(byAngle: 10 * CGFloat(M_PI)/180.0, duration: 1.0) //在1秒內旋轉10度（要轉換成鏡度）
        let rotateBack = SKAction.rotate(byAngle: -10 * CGFloat(M_PI)/180.0, duration: 1.0) //在1秒內轉回來10度的動作
        let rotateForwardAndBack = SKAction.sequence([rotate,rotateBack])//執行旋轉的動作
        let repeatRotation = SKAction.repeatForever(rotateForwardAndBack)
    
        let coverBall = childNode(withName: "coverBall") as! SKSpriteNode
        coverBall.run(repeatRotation)
        
        
        //製作AVAudioPlayer來播放背景音樂
        do{
            try myAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Main", ofType: "mp3")!))
        }catch {
            print("Main music error")
        }
        myAudio.numberOfLoops = -1 // -1 代表播放次數無限次
        myAudio.play() //播放背景音樂
        
        
        //產生AVaudioPlayer來播放海浪聲
        do{
            try seaAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "summer_beach", ofType: "mp3")!))
        }catch {
            print("sea music fail")
        }
        seaAudio.volume = 0.6  //調整音量
        seaAudio.numberOfLoops = 1  //重複循環播放
        seaAudio.play()
    }
    
    //轉換場景程式碼
    func playTheGame() {
        if let scene = GamePlay(fileNamed:"GamePlay") {
            myAudio.stop()
            scene.scaleMode = .aspectFill
            
            let myTransition1 = SKTransition.push(with: .left, duration: 0.5)
            view?.presentScene(scene, transition: myTransition1)
        }
    }
    
    func moreGame() {
        if let scene = MoreGame(fileNamed:"MoreGame") {
            myAudio.stop()
            scene.scaleMode = .aspectFill
            
            let myTransition2 = SKTransition.push(with: .left, duration: 0.5)
            view?.presentScene(scene, transition: myTransition2)
        }
    }
    
    func aboutTheGame() {
        //發出請接收showWebView的訊號
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showWebView"), object:nil)
        
        myAudio.play()
        seaAudio.stop()
    }
    
}

//生成按鈕
class SpriteKitButton:SKNode {
    
    //設定變數
    var defaultButton:SKSpriteNode!  //還沒按時顯示的圖
    var activeButton:SKSpriteNode!   //按下去時顯示的圖
    var action:()-> Void  //沒有參數，也沒有回傳值
    
    var buttonPressSound:SKAction!
    
    
    //生成按鈕的方法（用三個參數來生成按鈕）
    init(defaultButtonImage:String, activeButtonImage:String, buttonAction:@escaping ()-> Void) { //還沒按時的圖檔名、按下去時的圖檔名、按鈕的執行方法
        defaultButton  = SKSpriteNode(imageNamed: defaultButtonImage) //還沒按下去時，顯示的按鈕的圖
        activeButton = SKSpriteNode(imageNamed: activeButtonImage)  //按下去時，顯示的按鈕的圖
        action = buttonAction //把按下去的方法存在action的屬性中
        
        super.init()
        
        isUserInteractionEnabled = true //可以跟使用者互動
        addChild(activeButton)  //貼一個 按下按鈕的圖
        addChild(defaultButton) //貼上 還沒按下按鈕的圖
        
        buttonPressSound = SKAction.playSoundFileNamed("ButtonPressed.mp3", waitForCompletion: false) //碰到按鈕時，發出聲音
    }
    
    required init?(coder aDecode: NSCoder) {
        fatalError("Init fail")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("button touch began")
        activeButton.isHidden = false
        defaultButton.isHidden = true
        run(buttonPressSound)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("button touch moved")
        let touch = touches.first
        let location  = touch?.location(in: self)
        if defaultButton.contains(location!){
            activeButton.isHidden = false
            defaultButton.isHidden = true
        }else{
            activeButton.isHidden = true
            defaultButton.isHidden = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        if defaultButton.contains(location!) {  //按下去，放開的點有在設定的位置，就執行
            action()
        }
        activeButton.isHidden = true
        defaultButton.isHidden = false
    }
}
