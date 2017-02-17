//
//  ViewController.swift
//  scrollViewTest
//
//  Created by Swapnil Dhanwal on 24/08/16.
//  Copyright © 2016 Swapnil Dhanwal. All rights reserved.
//

import UIKit
import MWPhotoBrowser
import SDWebImage
import IDMPhotoBrowser

class SDInstantArticleViewController : UIViewController, UIScrollViewDelegate, MWPhotoBrowserDelegate {
    
    var viewHeight = CGFloat()
    var viewWidth = CGFloat()
    var navHeight = CGFloat()
    var scrollView = UIScrollView()
    var scrollHeight = CGFloat()
    var scrollWidth = CGFloat()
    var imageView = UIImageView()
    var imageHeight = CGFloat()
    var imageWidth = CGFloat()
    var lineLabel = UILabel()
    var infoView = UIView()
    var textView = UITextView()
    var photos = [MWPhoto]()
    var _photos = [IDMPhoto]()
    var passAttachments = [String:AnyObject]()
    var passMessage = String()
    var passHighResImageURL = String()
    var blur = UIBlurEffect()
    var blurView = UIVisualEffectView()
    var screenshot = UIImage()
    var headerView = UIView()
    var headerLabel = UILabel()
    var headerLineLabel = UILabel()
    var done = UIButton()
    var blurImageView = UIImageView()
    var browser = MWPhotoBrowser()
    var windowButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        blurImageView.image = self.screenshot
        self.view.addSubview(blurImageView)
        
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
        
        headerLineLabel = UILabel(frame: CGRect(x: 0, y: self.headerView.frame.maxY-1, width: self.headerView.bounds.width, height: 0.5))
        headerLineLabel.backgroundColor = getColor(red: 37, green: 50, blue: 55)
        self.headerView.addSubview(headerLineLabel)
        
        done = UIButton(type: .system)
        if let font = UIFont(name: "Avenir Book", size: 15)
        {
            s = NSMutableAttributedString(string: "Done", attributes: [NSFontAttributeName : font])
        }
        done.setAttributedTitle(s, for: .normal)
        done.frame = CGRect(x: self.headerView.frame.width*0.90-30, y: self.headerView.frame.height*0.75-10, width: 60, height: 20)
        done.addTarget(self, action: #selector(SDInstantArticleViewController.dismiss as (SDInstantArticleViewController) -> () -> ()), for: .touchUpInside)
        done.setTitleColor(getColor(red: 37, green: 50, blue: 55), for: .normal)
        headerView.addSubview(done)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        print(self.screenshot)
        
        //setting up the scroll view
        scrollView = UIScrollView(frame: CGRect(x: 0, y: self.headerView.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height-self.headerView.frame.height))
        scrollView.showsVerticalScrollIndicator = true
        scrollView.delegate = self
        scrollView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)
        
        //setting up the image view and adding it to the scroll view as a subview
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: 200))
        imageView.backgroundColor = UIColor(red: 61/255, green: 78/255, blue: 245/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        
        lineLabel = UILabel(frame: CGRect(x: 0, y: self.imageView.frame.maxY, width: self.scrollView.bounds.width, height: 1))
        lineLabel.backgroundColor = getColor(red: 64, green: 78, blue: 236)
        self.scrollView.addSubview(lineLabel)
        
        infoView = UIView(frame: CGRect(x: 0, y: self.lineLabel.frame.maxY, width: self.scrollView.bounds.width, height: 500))
        self.scrollView.addSubview(infoView)
        
        //Setting up the textView
        let text = passMessage
        textView.text = text
        textView.font = UIFont(name: "Avenir Book", size: 20)
        let textHeight = textView.sizeThatFits(CGSize(width: self.infoView.bounds.width-60, height: 1000)).height
        textView.frame = CGRect(x: 30, y: 20, width: self.infoView.bounds.width-60, height: textHeight)
        textView.textColor = getColor(red: 37, green: 50, blue: 55)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .all
        
        
        //need to change the info view frame again to such that its height remains the maximum of 500 and the height of the text view
        infoView.frame = CGRect(x: 0, y: self.lineLabel.frame.maxY, width: self.view.frame.width, height: max(self.textView.bounds.height+50,self.scrollView.frame.height-self.imageView.frame.height + 120))
        infoView.addSubview(textView)
        
        updateContentSize()
        
        //setting up the blur view
        blur = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.insertSubview(blurView, at: 1)
        
        
        //setting the images in the photo browser
        photos.removeAll()
        
        if let data = passAttachments["data"] as? [[String:AnyObject]]
        {
            for dataItem in data
            {
                if let subattachments = dataItem["subattachments"] as? [String:AnyObject]
                {
                    if let subData = subattachments["data"] as? [[String:AnyObject]]
                    {
                        for subDataItem in subData
                        {
                            if let media = subDataItem["media"] as? [String:AnyObject]
                            {
                                if let image = media["image"] as? [String:AnyObject]
                                {
                                    if let src = image["src"] as? String
                                    {
                                        _photos.append(IDMPhoto(url: URL(string: src)!))
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    if let media = dataItem["media"] as? [String:AnyObject]
                    {
                        if let image = media["image"] as? [String:AnyObject]
                        {
                            if let src = image["src"] as? String
                            {
                                photos.append(MWPhoto(url: URL(string : src)!))
                                _photos.append(IDMPhoto(url: URL(string: src)!))
                            }
                        }
                    }
                }
            }
        }
        
        
        
        imageView.setShowActivityIndicator(true)
        imageView.sd_setImage(with: URL(string: passHighResImageURL))
        imageView.sd_setImage(with: URL(string: passHighResImageURL)) { (image, error, cache, url) in
            
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SDInstantArticleViewController.tapped))
        tap.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tapped()
    {
        
        let browser = IDMPhotoBrowser(photos: self._photos)
        self.present(browser!, animated: true, completion: nil)
        
    }
    
    //MARK : MWPhotoBrowser delegate methods
    
    internal func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt
    {
        return UInt(1)
    }
    
    internal func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol!
    {
        return photos[Int(index)]
    }
    
    override func viewWillLayoutSubviews() {
        
        if let navHeight = self.navigationController?.navigationBar.frame.height
        {
        
            scrollView = UIScrollView(frame: CGRect(x: 0, y: navHeight, width: self.view.frame.width, height: self.view.frame.height))
            
            imageView.frame = CGRect(x: 0, y: navHeight-20, width: self.view.frame.width, height: 200)
            infoView.frame =  CGRect(x: 0, y: self.lineLabel.frame.maxY, width: self.view.frame.width, height: max(self.textView.frame.height+50,self.scrollView.frame.height-self.imageView.frame.height + 120))
            scrollView.contentSize = CGSize(width: imageView.frame.width, height: imageView.frame.height+infoView.frame.height+75)
            
        }
    }
    
    func dismiss()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissBrowser()
    {
        self.windowButton.removeFromSuperview()
        self.browser.dismiss(animated: true, completion: nil)
    }
    
    func updateContentSize()
    {
        var h : CGFloat = 0
        for view in self.scrollView.subviews
        {
            
            h += view.bounds.height
            
        }
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: h)
    }
    
    //This is probably the most important method of this class. It accounts for the zooming effect when the user drags down on the scroll view from the top.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = scrollView.contentOffset.y
        if (y < 0)
        {
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200 - y*1.5)
            self.imageView.center.y += (y*1.5)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

