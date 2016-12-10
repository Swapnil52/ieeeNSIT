//
//  customView.swift
//  spinner
//
//  Created by Swapnil Dhanwal on 15/10/16.
//  Copyright © 2016 Swapnil Dhanwal. All rights reserved.
//

import UIKit
import QuartzCore

class spinner: UIView, CAAnimationDelegate {
    
    public var isAnimating = Bool()
    public var flag = Bool()
    public var hidesWhenStopped = Bool()
    private var backLayerColor = UIColor()
    private var animation = CAAnimation()
    private var backLayer = CALayer()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        flag = true
        self.isAnimating = false
        self.backgroundColor = UIColor.clear
        self.backLayerColor = UIColor.white
        backLayer.bounds = self.layer.bounds
        backLayer.contentsRect = CGRect(x: layer.bounds.width/2, y: layer.bounds.height/2, width: layer.bounds.width, height: layer.bounds.height)
        self.isHidden = true
    }
    
    public func setBackgoundColor(color : UIColor)
    {
        
        self.backLayerColor = color
        self.backLayer.backgroundColor = color.cgColor
        
    }
    
    public func startAnimating()
    {
        
        
        if flag == true
        {
            self.isHidden = false
            let fullRotation = CGFloat(M_PI * 2)
            
            let animation = CAKeyframeAnimation()
            animation.keyPath = "transform.rotation.z"
            animation.duration = 0.75
            animation.isRemovedOnCompletion = false
            animation.repeatCount = Float.infinity
            animation.values = [fullRotation/4, fullRotation/2, fullRotation*3/4, fullRotation, fullRotation*5/4]
            self.layer.add(animation, forKey: "rotate")
            
        }
        
    }
    
    public func stopAnimating()
    {
        
        flag = false
        layer.removeAnimation(forKey: "rotate")
        if hidesWhenStopped == true
        {
            
            self.isHidden = true
            
        }
        
        
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        
        self.isAnimating = true
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        self.isAnimating = false
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let r = min(bounds.width/2, bounds.height/2)*0.75
        
        let p = UIBezierPath(arcCenter: CGPoint(x:self.bounds.width/2, y:self.bounds.height/2), radius: min(bounds.width/2, bounds.height/2)*0.75, startAngle: 0, endAngle: 3.14/2, clockwise: true)
        UIColor.cyan.setStroke()
        p.lineWidth = r*0.1
        p.lineCapStyle = .round
        p.stroke(with: .hue, alpha: 1)
        
    }
    
}
