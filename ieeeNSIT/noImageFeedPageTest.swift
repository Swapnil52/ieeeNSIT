//
//  noImageFeedPageTest.swift
//  connectFinal
//
//  Created by Swapnil Dhanwal on 03/10/16.
//  Copyright © 2016 SwApp. All rights reserved.
//

import UIKit

class noImageFeedPageTest: UIViewController, UIScrollViewDelegate {
    
    var viewHeight = CGFloat()
    var viewWidth = CGFloat()
    var navHeight = CGFloat()
    var headerView = UIView()
    var headerLabel = UILabel()
    var done = UIButton()
    var headerLineLabel = UILabel()
    var scrollView = UIScrollView()
    var infoView = UIView()
    var scrollHeight = CGFloat()
    var scrollWidth = CGFloat()
    var textView = UITextView()
    var textHeight = CGFloat()
    var textWidth = CGFloat()
    var passMessage = String()
    var blurImageView = UIImageView()
    var screenshot = UIImage()
    var blurView = UIVisualEffectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //setting up the blur view
        blurImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        blurImageView.image = self.screenshot
        self.view.addSubview(blurImageView)
        
        //setting the header view 
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        headerView.backgroundColor = UIColor.lightText
        self.view.addSubview(headerView)
        
        headerLabel = UILabel(frame: CGRect(x: self.headerView.bounds.width/2-40, y: self.headerView.bounds.height*0.75-20, width: 80, height: 40))
        var s = NSMutableAttributedString()
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            s = NSMutableAttributedString(string: "Post", attributes: [NSFontAttributeName : f])
        }
        headerLabel.attributedText = s
        headerLabel.textAlignment = .center
        headerLabel.textColor = getColor(red: 37, green: 50, blue: 55)
        headerView.addSubview(headerLabel)
        
        headerLineLabel = UILabel(frame: CGRect(x: 0, y: self.headerView.frame.maxY-1, width: self.headerView.bounds.width, height: 1))
        headerLineLabel.backgroundColor = getColor(red: 37, green: 50, blue: 55)
        self.headerView.addSubview(headerLineLabel)
        
        //setting up the done button
        done = UIButton(type: .system)
        
        if let font = UIFont(name: "Avenir Book", size: 15)
        {
            s = NSMutableAttributedString(string: "Done", attributes: [NSFontAttributeName : font])
        }
        done.setAttributedTitle(s, for: .normal)
        done.frame = CGRect(x: self.headerView.frame.width*0.90-30, y: self.headerView.frame.height*0.75-10, width: 60, height: 20)
        done.addTarget(self, action: #selector(noImageFeedPageTest.dismiss as (noImageFeedPageTest) -> () -> ()), for: .touchUpInside)
        done.setTitleColor(getColor(red: 37, green: 50, blue: 55), for: .normal)
        headerView.addSubview(done)
        
        //Adding the UIScrollView to the view
        scrollView = UIScrollView(frame: CGRect(x: 0, y: self.headerView.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - self.headerView.frame.height))
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        //Adding the info view
        infoView = UIView(frame: CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: 500))
        self.scrollView.addSubview(infoView)
        
        
        let text = passMessage
        textView.text = text
        textView.font = UIFont(name: "Avenir Book", size: 20)
        textHeight = textView.sizeThatFits(CGSize(width: self.infoView.bounds.width-60, height: 1000)).height
        textView.frame = CGRect(x: 30, y: 30, width: self.infoView.bounds.width-60, height: textHeight)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textColor = getColor(red: 37, green: 50, blue: 55)
        textView.dataDetectorTypes = .all
        
        //update infoView's frame
        infoView.frame = CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: max(textView.frame.height + 100, self.scrollView.bounds.height+20))
        infoView.addSubview(textView)

        //setting the scrollView's contentSize property
        updateContentSize()
        
        //Setting up the blur view
        let blur = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.insertSubview(blurView, at: 1)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //we need to change the frame dimensions in case the user changes the orientation of his/her phone and reset the frames
    func updateContentSize()
    {
        var h : CGFloat = 0
        for view in self.scrollView.subviews
        {
            h += view.frame.height
        }
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: h)
    }
    
    func dismiss()
    {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
