//
//  GameViewController.swift
//  Football
//
//  Created by Ting on 2015/10/20.
//  Copyright (c) 2015年 Ting. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false  //不要在畫面中顯示影格資訊
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = false //true代表不要管圖的順序，選擇false就是要選擇圖的順序
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
        
        //接收showWebView的訊號，並準備執行
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showWebView(_:)), name: NSNotification.Name(rawValue: "showWebView"), object: nil)
    }
    
    func showWebView(_ notification:Notification)  {
        print("oh yeah")
        let webViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "moreapp")
        self.present(webViewController, animated: true, completion: nil)
        
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
            return [UIInterfaceOrientationMask.portrait,UIInterfaceOrientationMask.portraitUpsideDown]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
