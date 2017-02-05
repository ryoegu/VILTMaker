//
//  SpeedChangeView.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2017/02/02.
//  Copyright © 2017年 Ryo Eguchi. All rights reserved.
//

import UIKit
import Spring

class SpeedChangeView: UIView {

    @IBOutlet var contentView: SpringView!
    
    @IBOutlet var slider: UISlider!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func loadXib() {
        Bundle.main.loadNibNamed("SpeedChangeView", owner: self, options: nil)
        self.contentView.frame = CGRect(x: 0, y: 0, width: 576, height: 200)
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor(hex: "6F1DFF").cgColor
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.cornerRadius = 4.0
        
        
        self.addSubview(contentView)
        
        self.contentView.isHidden = true
        
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        print(sender.value)
        
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
//            tmp.voiceSpeedFloat = sender.value
            
            UserDefaults.standard.set(sender.value, forKey: "voiceSpeed")
        
            tmp.docomoSpeakModel.speak("このスピードで再生します。")
        }
        
        
    }

    @IBAction func doneButtonPushed(_ sender: BorderButton) {
        closeView()
    }
    
    func closeView() {
        self.contentView.animation = "fadeOut"
        self.contentView.curve = "easeInOut"
        self.contentView.duration = 1.5
        self.contentView.animate()
    }
    
    func startAnimation() {
        self.contentView.isHidden = false
        self.contentView.animation = "fadeInUp"
        self.contentView.curve = "easeInOut"
        self.contentView.duration = 1.5
        self.contentView.animate()
    }

}
