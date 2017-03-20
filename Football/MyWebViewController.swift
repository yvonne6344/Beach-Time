//
//  MyWebViewController.swift
//  Football
//
//  Created by Ting on 2015/10/20.
//  Copyright © 2015年 Ting. All rights reserved.
//

import UIKit
import AVFoundation

class MyWebViewController: UIViewController {
    
    var buttonSound:AVAudioPlayer!
    
    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        do {
            try buttonSound = AVAudioPlayer(contentsOf: URL (fileURLWithPath: Bundle.main.path(forResource: "ButtonPressed", ofType: "mp3")!), fileTypeHint:nil)
        } catch {
            //Handle the error
        }
        myWebView.loadRequest(URLRequest(url:URL(string: "https://www.facebook.com/%E6%B2%99%E7%81%98%E6%99%82%E5%85%89-Beach-Time-758308407630370/")!))
    }
    
    @IBAction func backToMenu(_ sender: UIButton) {
        
        buttonSound.play()
        self.dismiss(animated: true, completion: nil)
        
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
