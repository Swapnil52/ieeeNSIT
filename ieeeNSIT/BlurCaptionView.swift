//
//  BlurCaptionView.swift
//  ieeeNSIT
//
//  Created by Swapnil Dhanwal on 03/02/17.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit
import IDMPhotoBrowser


class BlurCaptionView: IDMCaptionView {

    var blurView : UIVisualEffectView!
    var textView : UITextView!
    var _photo : IDMPhotoProtocol!
    
    override init!(photo: IDMPhotoProtocol!) {
        
        let screenBounds = UIScreen.main.bounds
        let screenWidth = screenBounds.width
        let screenHeight = screenBounds.height
        super.init(frame: CGRect(x : 0, y : screenHeight*0.8, width : screenWidth, height : screenHeight * 0.2))
        self._photo = photo
        self.setupCaption()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setupCaption() {
        
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.blurView.frame = self.bounds
        self.addSubview(self.blurView)
        self.textView = UITextView(frame: self.blurView.bounds)
        self.textView.backgroundColor = UIColor.clear
        self.textView.isEditable = false
        if let f = UIFont(name: "Avenir Book", size: 15)
        {
            
            self.textView.attributedText = NSMutableAttributedString(string: self._photo.caption!(), attributes: [NSFontAttributeName : f, NSForegroundColorAttributeName : UIColor.white])
            
        }
        self.blurView.addSubview(self.textView)
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        if self.textView.text.characters.count == 0
        {
            return CGSize.zero
        }
        return CGSize(width: UIScreen.main.bounds.width, height: self.textView.bounds.height)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
