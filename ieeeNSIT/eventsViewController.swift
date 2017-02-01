//
//  eventsViewController.swift
//  eventsSwipe
//
//  Created by Swapnil Dhanwal on 28/11/16.
//  Copyright © 2016 Swapnil Dhanwal. All rights reserved.
//

import UIKit
import SDWebImage
import EventKit

class eventsViewController : UIViewController {
    
    var mainView = UIView()
    var shadowView = UIView()
    var blurView  = UIVisualEffectView()
    var imageView = UIImageView()
    var textView = UITextView()
    var lineLabel = UILabel()
    var dateLabel = UILabel()
    var nameLabel = UILabel()
    var pan = UIPanGestureRecognizer()
    var count = Int()
    var index = Int()
    var swipeEnabled = Bool()
    var events = [[String : AnyObject]]()
    var spinner = UIActivityIndicatorView()
    var retryButton = UIButton()
    var refreshView = UIView()
    var refreshImageView = UIImageView()
    var eventIds = [String]()
    var toast : SwapToastView!
    var pageIndexLabel = UILabel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //setting up properties. Count set to 5 for demo purposes. index = 0 for first page.
        count = 5;
        index = 0;
        swipeEnabled = false
        events.removeAll()
        
        //setting up the refresher view
        refreshView = UIView(frame: CGRect(x: self.view.bounds.width/2 - self.view.bounds.width*0.20/2, y: self.mainView.frame.maxY+self.view.bounds.width*0.20/2, width: self.view.bounds.width*0.20, height: self.view.bounds.width*0.20))
        refreshImageView = UIImageView(frame: self.refreshView.bounds)
        refreshImageView.image = UIImage(named: "eventsRefresher.png")
        self.refreshView.addSubview(self.refreshImageView)
        refreshView.alpha = 0
        self.view.addSubview(refreshView)
        
        showMainView()
        //setting up the spinner
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        let frame = CGRect(x: self.mainView.bounds.width/2 - 50, y: self.mainView.bounds.height/2 - 50, width: 100, height: 100)
        spinner.frame = frame
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.color = getColor(red: 61, green: 78, blue: 245)
        self.mainView.addSubview(spinner)
        
        //setting up the pageIndexLabel
        self.pageIndexLabel = UILabel(frame: CGRect(x: self.view.bounds.width/2-30, y: self.mainView.frame.maxY-30, width: 60, height: 20))
        self.pageIndexLabel.text = "\(self.index+1)/5"
        self.pageIndexLabel.font = UIFont(name: "Avenir Book", size: 15)
        self.pageIndexLabel.textAlignment = .center
        self.view.addSubview(self.pageIndexLabel)

        
        downloadEvents { (success, events, count) in
            
            if success == true && Reachability.isConnectedToNetwork() == true
            {
                self.count = count
                self.events = events
                
                //show toasts
                self.toast = SwapToastView("Swipe to view events!", UIColor(red : 61/255, green : 78/255, blue : 245/255, alpha : 1), UIColor.white, 2, completion: {
                    
                    self.toast.removeFromSuperview()
                    self.toast = SwapToastView("Pull down to refresh!", UIColor(red : 61/255, green : 78/255, blue : 245/255, alpha : 1), UIColor.white, 2, completion: {
                        
                        self.toast.removeFromSuperview()
                        self.spinner.stopAnimating()
                        self.displayEvent(self.index, completionHandler: {
                            
                            self.swipeEnabled = true
                            
                        })
                        
                    })
                    self.toast.layer.borderColor = UIColor.white.cgColor
                    self.toast.layer.borderWidth = 0.5
                    self.view.addSubview(self.toast)
                    
                })
                self.toast.layer.borderColor = UIColor.white.cgColor
                self.toast.layer.borderWidth = 0.5
                self.view.addSubview(self.toast)
                
            }
            
            else
            {
                self.displayError()
                self.spinner.stopAnimating()
            }
            
        }
        
    }
    
    func showMainView()
    {
        
        //setting up the main view. Add subviews to this view as desired.
        mainView.layer.cornerRadius = 10
        mainView.frame = CGRect(x: self.view.bounds.width/2-self.view.bounds.width*0.85/2, y: self.view.bounds.height/2-self.view.bounds.height*0.85/2, width: self.view.bounds.width*0.85, height: self.view.bounds.height*0.85)
        mainView.backgroundColor = getColor(red: 235, green: 235, blue: 241)
//        mainView.backgroundColor = UIColor.white
        mainView.layer.shadowPath = UIBezierPath(roundedRect: self.mainView.bounds, cornerRadius: 10).cgPath
        mainView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        mainView.layer.shadowOpacity = 0.4
        mainView.layer.shadowRadius = 5
        mainView.layer.masksToBounds = false
        self.view.addSubview(mainView)
        
        //setting up the pan gesture recogniser
        pan = UIPanGestureRecognizer(target: self, action: #selector(eventsViewController.drag(gesture:)))
        self.mainView.addGestureRecognizer(pan)
        self.mainView.isUserInteractionEnabled = true
        

    }
    
    func displayEvent(_ i : Int, completionHandler : @escaping () -> Void)
    {
        
        for view in self.mainView.subviews
        {
            if view != self.blurView
            {
                view.removeFromSuperview()
            }
        }
        
        if self.events[self.index].count > 0
        {
            let cover = self.events[self.index]["cover"]
            if let source = cover?["source"] as? String
            {
                
                let currentImageURL =  URL(string: source)
                //cancel current image download, if extant
                self.imageView.sd_cancelCurrentImageLoad()
                self.imageView.contentMode = .scaleToFill
                self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.mainView.bounds.width, height: self.mainView.bounds.height * 0.3))
                self.imageView.backgroundColor = getColor(red: 68, green: 74, blue: 236)
                self.imageView.setShowActivityIndicator(true)
                self.imageView.setIndicatorStyle(.whiteLarge)
                
                //round upper corners
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: self.imageView.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
                self.imageView.layer.mask = maskLayer
                
                self.imageView.sd_setImage(with: currentImageURL) { (image, error, cache, url) in
                    
                    //do something
                    self.imageView.clipsToBounds = false
                    
                }

                
            }
            
        }
        self.mainView.addSubview(self.imageView)
        self.mainView.backgroundColor = getColor(red: 235, green: 235, blue: 241)
//        self.mainView.backgroundColor = UIColor.white

        self.lineLabel = UILabel(frame: CGRect(x: 0, y: self.imageView.frame.maxY, width: self.mainView.frame.width, height: 3))
        self.lineLabel.backgroundColor = getColor(red: 61, green: 78, blue: 245)
        self.mainView.addSubview(self.lineLabel)

        self.dateLabel = UILabel(frame: CGRect(x: 0.65*self.mainView.bounds.width - 10, y: self.lineLabel.frame.maxY+10, width: self.mainView.bounds.width * 0.35, height: 40))
        let date = self.events[self.index]["start_time"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let newDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yy,HH:mm"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let dateString = dateFormatter.string(from: newDate!)
        self.dateLabel.textAlignment = .center
        if let f = UIFont(name: "Avenir Book", size: 13)
        {
            let s = NSMutableAttributedString(string: "\(dateString)", attributes: [NSFontAttributeName : f])
            self.dateLabel.attributedText = s
            self.dateLabel.textColor = getColor(red: 37, green: 50, blue: 55)
        }
        self.dateLabel.layer.cornerRadius = 5
        self.dateLabel.clipsToBounds = true
        self.mainView.addSubview(self.dateLabel)
        
        self.nameLabel = UILabel(frame: CGRect(x: 10, y: self.lineLabel.frame.maxY + 10, width: self.mainView.frame.width*0.50, height: 40))
        if let f = UIFont(name: "Avenir Book", size: 13)
        {
            let s = NSMutableAttributedString(string: "\(self.events[self.index]["name"] as! String)", attributes: [NSFontAttributeName : f])
            self.nameLabel.numberOfLines = -1
            self.nameLabel.attributedText = s
            self.nameLabel.textColor = getColor(red: 37, green: 50, blue: 55)

        }
        self.mainView.addSubview(self.nameLabel)
        
        self.textView = UITextView(frame: CGRect(x: 10, y: self.nameLabel.frame.maxY, width: self.mainView.bounds.width - 20, height: self.mainView.bounds.height - (self.nameLabel.frame.maxY + 5)))
        self.textView.backgroundColor = getColor(red: 235, green: 235, blue: 241)
//        self.textView.backgroundColor = UIColor.white
        
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            let s = NSMutableAttributedString(string: "\(self.events[self.index]["description"]!)", attributes: [NSFontAttributeName : f])
            self.textView.attributedText = s
            self.textView.textColor = getColor(red: 37, green: 50, blue: 55)
        }
        self.textView.isEditable = false
        self.textView.dataDetectorTypes = .all
        self.textView.layer.cornerRadius = 5
        self.mainView.addSubview(self.textView)
        
        completionHandler()

        
    }
    
    func displayError()
    {
        //show refresh button in mainView
        
        for view in self.mainView.subviews
        {
            if view != self.blurView
            {
                view.removeFromSuperview()
            }
        }
        
        retryButton = UIButton(type: .custom)
        retryButton.frame = CGRect(x: self.mainView.bounds.width/2 - 50, y: self.mainView.bounds.height/2 - 50, width: 100, height: 100)
        let buttonImage = UIImage(named: "refresh.png")
        retryButton.setImage(buttonImage, for: .normal)
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            let s = NSMutableAttributedString(string: "Retry", attributes: [NSFontAttributeName : f])
            retryButton.setAttributedTitle(s, for: .normal)
        }
        retryButton.addTarget(self, action: #selector(eventsViewController.refresh), for: .touchUpInside)
        mainView.addSubview(retryButton)
        
    }
    
    func refresh()
    {
        index = 0;
        swipeEnabled = false
        events.removeAll()
        
        for view in self.mainView.subviews
        {
            view.removeFromSuperview()
        }
        
        showMainView()
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.frame = CGRect(x: self.mainView.bounds.width/2 - 50, y: self.mainView.bounds.height/2 - 50, width: 100, height: 100)
        spinner.color = getColor(red: 61, green: 78, blue: 245)
        spinner.hidesWhenStopped = true
        self.mainView.addSubview(spinner)
        

        spinner.startAnimating()
        
        downloadEvents { (success, events, count) in
            
            if success == true && Reachability.isConnectedToNetwork() == true
            {
                self.count = count
                self.events = events
                self.spinner.stopAnimating()
                self.displayEvent(self.index, completionHandler: {
                    
                    self.swipeEnabled = true
                    self.updatePageIndex()
                    
                })
            }
                
            else
            {
                self.displayError()
                self.spinner.stopAnimating()
            }
            
        }

    }
    
    
    
    func downloadEvents(completionHandler : @escaping (_ success : Bool, _ array : [[String:AnyObject]], _ count : Int) -> Void)
    {
        let url = URL(string: "https://graph.facebook.com/v2.5/278952135548721/events?limit=5&fields=name,start_time,description,cover&access_token=CAAGZAwVFNCKgBAANhEYok6Xh7Q7UZBeTZCUqwPDLYhRZCmNn0igI8SE339jSn2zjxCpA1JUmXHm55XKVXslhdKKoTF3b5sLsiZBVd0ylYwX3MIGOnRyzn0T2XVywwoPKP7ML9WZCqELGRuIGxoM8ia05CiUiqcbgsb4wzTuBKkvKaqb7TPt2VnPtprRZBWda4kZD")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error
            {
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "An Error Occurred", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                        print("JSON Serialisation failed")
                        completionHandler(false, [], 0)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            else
            {
                if let data = data
                {
                    DispatchQueue.main.async {
                        
                        do
                        {
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                            
                            if let jsonData = jsonData as? [String : AnyObject]
                            {
                                
                                if let data = jsonData["data"] as? [[String:AnyObject]]
                                {
                                    
                                    completionHandler(true, data, data.count)
                                    
                                }
                                else
                                {
                                    completionHandler(false, [], 0)
                                }
                                
                            }
                        }
                        catch
                        {
                            print("JSON Serialisation failed")
                            completionHandler(false, [], 0)
                        }
                        
                    }
                }
            }
            
        }
        task.resume()
        
    }
    
    func updatePageIndex()
    {
        
        self.pageIndexLabel.text = "\(self.index+1)/5"
        
    }
    
    func drag(gesture : UIPanGestureRecognizer)
    {
        let translation = gesture.translation(in: self.view)
        let velocity = gesture.velocity(in: self.view)
        let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        self.mainView.layer.setAffineTransform(transform)
        
        //rotate the refresher image view if dragging downwards
        if translation.y > 0 && velocity.y > 0
        {
            let alphaScale = translation.y/100
            self.refreshView.alpha = alphaScale
            if (1*translation.y/30*3.14/180 < 0.2)
            {
                let transform = self.refreshView.layer.affineTransform()
                let rotate = CGAffineTransform(rotationAngle: 1*translation.y/30*3.14/180)
                let t = (transform.concatenating(rotate))
                self.refreshView.layer.setAffineTransform(t)
            }
        }
        
        if gesture.state == .ended
        {
            let x = translation.x
            
            //get rid of the refresh view if the user has swiped far anough to initiate the page swipe animation
            if (1*translation.y/30*3.14/180 > 0.1)
            {
                self.refresh()
            }
            
            //initiate the page swipe animation if the user has swiped far enough
            if x >= -self.view.bounds.width*0.25 && x <= self.view.bounds.width*0.25
            {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .allowUserInteraction, animations: {
                    
                    self.mainView.layer.setAffineTransform(CGAffineTransform.identity)
                    self.refreshView.alpha = 0
                    self.refreshView.layer.setAffineTransform(CGAffineTransform.identity)
                    
                    }, completion: nil)
            }
            else
            {
                if (x < self.view.bounds.width*0.25)
                {
                    swipeLeft(gesture)
                }
                else
                {
                    swipeRight(gesture)
                }
            }
        }
    }
    
    func swipeLeft(_ gesture : UIPanGestureRecognizer)
    {
        
        if self.index < self.count-1 && self.swipeEnabled == true
        {
            
            UIView.animate(withDuration: 0.4, animations: {
                
                let transform = CGAffineTransform(translationX: -1000, y: 0)
                self.mainView.layer.setAffineTransform(transform)
                self.refreshView.alpha = 0
                self.refreshView.layer.setAffineTransform(CGAffineTransform.identity)
                
            }) { (success) in
                
                self.mainView.layer.transform = CATransform3DIdentity
                self.mainView.layer.transform = CATransform3DMakeTranslation(1000, 0, 0)
                self.index += 1
                self.updatePageIndex()
                self.displayEvent(self.index, completionHandler: { 
                    
                })
                
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .allowUserInteraction, animations: {
                    
                    self.mainView.layer.transform = CATransform3DIdentity
                    
                    }, completion: { (success) in
                        
                        
                })
                
            }

        }
        else
        {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .allowUserInteraction,  animations: {
                
                self.mainView.layer.setAffineTransform(CGAffineTransform.identity)
                self.refreshView.alpha = 0
                self.refreshView.layer.setAffineTransform(CGAffineTransform.identity)
                
                }, completion: nil)

        }
    }
    
    func swipeRight(_ gesture : UIPanGestureRecognizer)
    {
        
        if self.index > 0 && self.swipeEnabled == true
        {
            UIView.animate(withDuration: 0.4, animations: {
                
                let transform = CGAffineTransform(translationX: 1000, y: 0)
                self.mainView.layer.setAffineTransform(transform)
                self.refreshView.alpha = 0
                self.refreshView.layer.setAffineTransform(CGAffineTransform.identity)

                
            }) { (success) in
                
                self.mainView.layer.transform = CATransform3DIdentity
                self.mainView.layer.transform = CATransform3DMakeTranslation(-1000, 0, 0)
                self.index -= 1
                self.updatePageIndex()
                self.displayEvent(self.index, completionHandler: { 
                    
                })
                
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .allowUserInteraction, animations: {
                    
                    self.mainView.layer.transform = CATransform3DIdentity
                    
                    }, completion: { (success) in
                        
                        
                })
            }
        }
        else
        {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .allowUserInteraction,  animations: {
                
                self.mainView.layer.setAffineTransform(CGAffineTransform.identity)
                self.refreshView.alpha = 0
                self.refreshView.layer.setAffineTransform(CGAffineTransform.identity)
                
                }, completion: nil)

        }
    }
    
    override func viewWillLayoutSubviews() {
        
        mainView.frame = CGRect(x: self.view.bounds.width/2-self.view.bounds.width*0.85/2, y: self.view.bounds.height/2-self.view.bounds.height*0.85/2, width: self.view.bounds.width*0.85, height: self.view.bounds.height*0.85)
        mainView.layer.shadowPath = UIBezierPath(roundedRect: self.mainView.bounds, cornerRadius: 10).cgPath
        mainView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        mainView.layer.shadowOpacity = 0.3
        mainView.layer.shadowRadius = 5
//        self.mainView.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

