//
//  File.swift
//  ieeeNSIT
//
//  Created by Swapnil Dhanwal on 14/10/16.
//  Copyright © 2016 Swapnil Dhanwal. All rights reserved.
//

import Foundation
import UIKit

class colorManager : NSObject
{
    
    public func colorRgb(red : CGFloat, green : CGFloat, blue : CGFloat) -> UIColor
    {
        
        let color = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        return color
        
    }
    
    public func colorHex(hex : String) -> UIColor
    {
        
        let r = Int("0x\(hex.startIndex)\(hex.index(after: hex.startIndex))")
        let g = Int("0x\(hex.index(hex.startIndex, offsetBy: 2))\(hex.index(hex.startIndex, offsetBy: 3))")
        let b = Int("0x\(hex.index(hex.startIndex, offsetBy: 4))\(hex.index(hex.startIndex, offsetBy: 5))")
        
        return colorRgb(red: CGFloat(r!), green: CGFloat(g!), blue: CGFloat(b!))
        
    }
    
}
