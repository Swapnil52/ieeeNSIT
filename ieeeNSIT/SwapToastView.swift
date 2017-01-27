//
//  SwapToastView.swift
//  SwapToast
//
//  Created by Swapnil Dhanwal on 26/01/17.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class SwapToastView: UIView {
    
    private var messageLabel = UILabel()
    private var timer = Timer()
    private var superRect = CGRect()
    private var rect = CGRect()
    private var time = Int()
    
    
    public var toastMessage = String()
    private var completionHandler : () -> Void
    
    init(_ message : String, _ backColor : UIColor, _ textColor : UIColor, _ t : Int, completion : @escaping () -> Void)
    {
        //set private variables
        toastMessage = message
        let mainScreenBounds = UIScreen.main.bounds
        rect = mainScreenBounds.applying(CGAffineTransform(scaleX: 1, y: 0.1))
        time = t
        completionHandler = completion
        //initialise self
        super.init(frame: rect)
        
        //set properties
        self.backgroundColor = backColor
        messageLabel = UILabel(frame: rect)
        messageLabel.textColor = textColor
        self.addSubview(messageLabel)
        self.messageLabel.text = message
        self.messageLabel.textAlignment = .center
        self.messageLabel.font = UIFont(name: "Avenir Book", size: 20)
        self.show(time)
        
    }
    
    func show(_ time : Int)
    {
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SwapToastView.fire(_:)), userInfo: nil, repeats: true)
        self.timer.fire()
        self.layer.setAffineTransform(CGAffineTransform(translationX: -1000, y: 0))
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [], animations: {
            
            self.layer.setAffineTransform(CGAffineTransform.identity)
            
        }) { (success) in
            
            
            
        }
        
    }
    
    func fire(_ timer : Timer)
    {
        self.time = self.time - 1
        if self.time == 0
        {
            timer.invalidate()
            UIView.animate(withDuration: 0.4, animations: { 
                
                self.alpha = 0
                
            }, completion: { (success) in
                
                self.completionHandler()
                
            })
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
