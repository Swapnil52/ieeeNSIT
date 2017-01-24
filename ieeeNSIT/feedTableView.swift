//
//  feedTableView.swift
//  ieeeNSIT
//
//  Created by Swapnil Dhanwal on 11/10/16.
//  Copyright © 2016 Swapnil Dhanwal. All rights reserved.
//

import UIKit
import SDWebImage
import MWPhotoBrowser

class feedTableView: UITableViewController, MWPhotoBrowserDelegate {
    
    var next20 = String()
    var attachments = [String:[String:AnyObject]]()
    var highResImageURLs = [String:String]()
    var messages = [String]()
    var likes = [NSInteger]()
    var dates = [String]()
    var ids = [String]()
    var refresher = UIRefreshControl()
    var refresherLabel = UILabel()
    var isRefresherAnimating = Bool()
    var navSpinner = UIActivityIndicatorView()
    var didScrollOnce = Bool()
    var photos = [MWPhoto]()
    var s = UIActivityIndicatorView()
    var headerView = UIView()
    var headerLabel = UILabel()
    var screenshot = UIImage()
    var windowButton = UIButton()
    var browser = MWPhotoBrowser()
    var statusBlurView = UIVisualEffectView()
    var placeholderImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let window = UIApplication.shared.delegate?.window
        {
            let statusBlur = UIBlurEffect(style: .light)
            statusBlurView = UIVisualEffectView(effect: statusBlur)
            statusBlurView.frame = UIApplication.shared.statusBarFrame
            window?.addSubview(statusBlurView)
        }
        
        let url = "https://graph.facebook.com/278952135548721/posts?limit=20&fields=id,full_picture,picture,from,shares,attachments,message,object_id,link,created_time,comments.limit(0).summary(true),likes.limit(0).summary(true)&access_token=CAAGZAwVFNCKgBAANhEYok6Xh7Q7UZBeTZCUqwPDLYhRZCmNn0igI8SE339jSn2zjxCpA1JUmXHm55XKVXslhdKKoTF3b5sLsiZBVd0ylYwX3MIGOnRyzn0T2XVywwoPKP7ML9WZCqELGRuIGxoM8ia05CiUiqcbgsb4wzTuBKkvKaqb7TPt2VnPtprRZBWda4kZD"
        
        s = UIActivityIndicatorView(frame: CGRect(x:self.view.bounds.width/2-100, y:self.view.bounds.height/2-50-100, width:200, height:200))
        s.activityIndicatorViewStyle = .gray
        s.hidesWhenStopped = true
        self.view.addSubview(s)
        
        //configure the refresher
        refresher.addTarget(self, action: #selector(feedTableView.refresh), for: .valueChanged)
        configureRefresher()
        self.view.addSubview(refresher)
        
        //configure the navigation bar spinner
        navSpinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navSpinner)
        navSpinner.hidesWhenStopped = true
        didScrollOnce = false
        
        self.view.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.clear
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            
            
            s.startAnimating()
            downloadData(url: url, completionHandler: { (success, jsonData) in

                if success == true
                {

                    DispatchQueue.main.async(execute: {

                        self.parseJSON(jsonData: jsonData)
                        self.saveData()
                        self.isRefresherAnimating = false
                        self.s.stopAnimating()
                        UIView.setAnimationsEnabled(false)
                        CATransaction.begin()
                        self.tableView.reloadData()
                        CATransaction.commit()
                        CATransaction.setCompletionBlock { () -> Void in

                            UIView.setAnimationsEnabled(true)
                        }
                        self.isRefresherAnimating = true
                        self.tableView.isHidden = false
                        
                    })
                    
                }
                else
                {
                    
                    do
                    {
                        
                        try self.loadData()
                        self.s.stopAnimating()
                        
                    }
                    catch
                    {
                        
                        self.s.startAnimating()
                        self.downloadData(url: url, completionHandler: { (success, jsonData) in
                            
                            if success == true
                            {
                                
                                DispatchQueue.main.async(execute: {
                                    
                                    self.parseJSON(jsonData: jsonData)
                                    self.saveData()
                                    self.isRefresherAnimating = false
                                    self.s.stopAnimating()
                                    UIView.setAnimationsEnabled(false)
                                    CATransaction.begin()
                                    self.tableView.reloadData()
                                    CATransaction.commit()
                                    CATransaction.setCompletionBlock { () -> Void in
                                        
                                        UIView.setAnimationsEnabled(true)
                                    }
                                    self.isRefresherAnimating = true
                                    self.tableView.isHidden = false
                                    
                                })
                                
                            }
                            else
                            {
                                DispatchQueue.main.async(execute: {
                                    
                                    self.s.stopAnimating()
                                    self.showPlaceholder()
                                    
                                })
                                
                            }
                            
                        })
                        
                        
                    }

                    
                }
                
            })

            
        }
        else
        {
            do
            {
    
                try loadData()
                s.stopAnimating()
                
            }
            catch
            {
                
                s.startAnimating()
                downloadData(url: url, completionHandler: { (success, jsonData) in
                    
                    if success == true
                    {
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.parseJSON(jsonData: jsonData)
                            self.saveData()
                            self.isRefresherAnimating = false
                            UIView.setAnimationsEnabled(false)
                            CATransaction.begin()
                            self.tableView.reloadData()
                            CATransaction.commit()
                            CATransaction.setCompletionBlock { () -> Void in
                                
                                UIView.setAnimationsEnabled(true)
                            }
                            self.isRefresherAnimating = true
                            self.tableView.isHidden = false
                            self.s.stopAnimating()
                        })
                        
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: {
                            
                            
                            self.s.stopAnimating()
                            self.showPlaceholder()
                            
                        })
                    
                    }
                    
                })

                
            }
        }
        
    }
    
    //MARK : Show placeholder image when there's no data to show
    
    func showPlaceholder()
    {
        
        //stop spinner from animating, if it is
        if (s.isAnimating)
        {
            s.stopAnimating()
        }
        //set up the placeholder image view ('Nothing to do here')
        self.placeholderImageView = UIImageView(frame: CGRect(x: self.view.bounds.width/2-100, y: self.view.bounds.height/2 - 100, width: 200, height: 200))
        self.placeholderImageView.image = UIImage(named: "placeholder.png")
        self.placeholderImageView.contentMode = .scaleAspectFit
        self.view.addSubview(placeholderImageView)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        self.refresherLabel.frame = self.refresher.bounds
        
    }
    
    //MARK : Loading data from offline storage
    
    func loadData() throws
    {
        
        if UserDefaults.standard.object(forKey: "ids") == nil
        {
            
            let error = NSError(domain: "NSUserDefaults was nil", code: 120, userInfo: nil)
            throw error as Error
            
        }
        
        self.messages = UserDefaults.standard.object(forKey: "messages") as! [String]
        self.attachments = UserDefaults.standard.object(forKey: "attachments") as! [String:[String:AnyObject]]
        self.highResImageURLs = UserDefaults.standard.object(forKey: "highResImageURLs") as! [String:String]
        self.dates = UserDefaults.standard.object(forKey: "dates") as! [String]
        self.ids = UserDefaults.standard.object(forKey: "ids") as! [String]
        self.likes = UserDefaults.standard.object(forKey: "likes") as! [NSInteger]
        self.next20 = UserDefaults.standard.object(forKey: "next20") as! String
        
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        
        self.tableView.reloadData()
        CATransaction.commit()
        CATransaction.setCompletionBlock { () -> Void in
            
            UIView.setAnimationsEnabled(true)
        }

        
    }
    
    //MARK : Offline storage
    
    func saveData()
    {
        
        UserDefaults.standard.set(self.messages, forKey: "messages")
        UserDefaults.standard.set(self.attachments, forKey: "attachments")
        UserDefaults.standard.set(self.highResImageURLs, forKey: "highResImageURLs")
        UserDefaults.standard.set(self.dates, forKey: "dates")
        UserDefaults.standard.set(self.ids, forKey: "ids")
        UserDefaults.standard.set(self.likes, forKey: "likes")
        UserDefaults.standard.set(self.next20, forKey: "next20")
        
    }
    
    //JSON Parser
    
    func parseJSON(jsonData : NSDictionary)
    {
        
        
        self.messages.removeAll()
        self.attachments.removeAll()
        self.dates.removeAll()
        self.ids.removeAll()
        self.next20.removeAll()
        self.likes.removeAll()
        
        if let jsonData = jsonData as? [String:AnyObject]
        {
            
            if let paging = jsonData["paging"] as? [String:AnyObject]
            {
                
                if let next20 = paging["next"] as? String
                {
                    
                    self.next20 = next20
                    
                }
                
            }
            if let items = jsonData["data"] as? [[String:AnyObject]]
            {
                
                for item in items
                {
                    
                    if let id = item["id"] as? String
                    {
                        
                        self.ids.append(id)
                        
                    }
                    
                    if let attachments = item["attachments"] as? [String:AnyObject]
                    {
                        self.attachments[(item["id"] as? String)!] = attachments
                        if let attachmentData = attachments["data"] as? [[String:AnyObject]]
                        {
                            for x in attachmentData
                            {
                                if let subattachments = x["subattachments"] as? [String:AnyObject]
                                {
                                    if let subData = subattachments["data"] as? [[String:AnyObject]]
                                    {
                                        for y in subData
                                        {
                                            if let media = y["media"] as? [String:AnyObject]
                                            {
                                                if let image = media["image"] as? [String:AnyObject]
                                                {
                                                    if let src = image["src"] as? String
                                                    {
                                                        self.highResImageURLs[item["id"] as! String] = src
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    break;
                                }
                                else
                                {
                                    break;
                                }
                                
                            }
                            
                            for x in attachmentData
                            {
                                
                                if let media = x["media"] as? [String:AnyObject]
                                {
                                    if let image = media["image"] as? [String:AnyObject]
                                    {
                                        if let src = image["src"] as? String
                                        {
                                            
                                            self.highResImageURLs[item["id"] as! String] = src
                                            
                                            
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    }
                    
                    if let message = item["message"] as? String
                    {
                        
                        self.messages.append(message)
                        
                    }
                    else
                    {
                        
                        self.messages.append("")
                        
                    }
                    
                    if let likes = item["likes"] as? [String:AnyObject]
                    {
                        
                        if let summary = likes["summary"] as? [String:AnyObject]
                        {
                            
                            if let totalCount = summary["total_count"] as? NSInteger
                            {
                                
                                self.likes.append(totalCount)
                                
                            }
                            
                        }
                        
                    }
                    
                    if let date = item["created_time"] as? String
                    {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                        let newDate = dateFormatter.date(from: date)
                        dateFormatter.dateFormat = "dd-MM-yyyy,HH:mm"
                        dateFormatter.amSymbol = "AM"
                        dateFormatter.pmSymbol = "PM"
                        let dateString = dateFormatter.string(from: newDate!)
                        self.dates.append(dateString)
                        
                    }
                    
                }
                
            }
            
        }

        
    }
    
    func refresh()
    {
        
        //remove the placeholder image view from its superview i.e. self.view
        self.placeholderImageView.removeFromSuperview()
        
        animateRefresher(colorIndex: 0)
        
        let url = "https://graph.facebook.com/278952135548721/posts?limit=20&fields=id,full_picture,picture,from,shares,attachments,message,object_id,link,created_time,comments.limit(0).summary(true),likes.limit(0).summary(true)&access_token=CAAGZAwVFNCKgBAANhEYok6Xh7Q7UZBeTZCUqwPDLYhRZCmNn0igI8SE339jSn2zjxCpA1JUmXHm55XKVXslhdKKoTF3b5sLsiZBVd0ylYwX3MIGOnRyzn0T2XVywwoPKP7ML9WZCqELGRuIGxoM8ia05CiUiqcbgsb4wzTuBKkvKaqb7TPt2VnPtprRZBWda4kZD"
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            self.s.startAnimating()
            self.downloadData(url: url) { (success, jsonData) in
                
                DispatchQueue.main.async(execute: { 
                    
                    if success == true
                    {
                        
                        self.parseJSON(jsonData: jsonData)
                        
                        self.tableView.isHidden = true
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        
                        self.saveData()
                        self.refresher.endRefreshing()
                        self.isRefresherAnimating = false
                        self.s.stopAnimating()
                    }
                    else
                    {
                        
                        self.saveData()
                        self.refresher.endRefreshing()
                        self.isRefresherAnimating = false
                        self.s.stopAnimating()
                        
                    }

                    
                })
                
                
            }
            
        }
        else
        {
             
            let alert = UIAlertController(title: "An Error Occurred", message: "The internet connection seems to be offline", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                if self.refresher.isRefreshing
                {
                    
                    self.refresher.endRefreshing()
                    self.isRefresherAnimating = false
                    
                }
                
                if self.s.isAnimating
                {
                    
                    self.s.stopAnimating()
                    self.isRefresherAnimating = false
                    
                }
                
                do
                {
                    try self.loadData()
                }
                catch
                {
                    
                    self.showPlaceholder()
                    
                }
                
            }))
            self.present(alert, animated: true, completion: {
            
                
            
            })
            
           
        }
    }
    
    func downloadData(url : String, completionHandler : @escaping (_ done : Bool, _ jsonData : NSDictionary)->Void)
    {
        
        let session = URLSession.shared
        let task = session.dataTask(with: URL(string : url)!) { (data, response, error) in
            
            if let error = error
            {
                
                let alert = UIAlertController(title: "An Error Occurred", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    if self.refresher.isRefreshing
                    {
                        self.refresher.endRefreshing()
                    }
                    completionHandler(false, [:])
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                
                if let data = data
                {
                    
                    do
                    {
                        
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        completionHandler(true, jsonData!)
                        
                    }
                    catch
                    {
                        
                        print("JSON serialisation failed")
                        
                    }
                    
                }
                
            }
            
        }
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let t1 = cell.layer.affineTransform()
        let t2 = t1.translatedBy(x: -100, y: -100)
        cell.layer.setAffineTransform(t2)
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            
            cell.layer.setAffineTransform(CGAffineTransform.identity)
            cell.alpha = 1
            
            }) { (success) in
                
            
                
        }
    }
    
    //MARK : Configure the refresh control for animation
    
    func configureRefresher()
    {
        
        for i in self.refresher.subviews
        {
            
            i.removeFromSuperview()
            
        }
        
        self.refresher.backgroundColor = self.tableView.backgroundColor
        self.isRefresherAnimating = true
        var ms = NSMutableAttributedString()
        if let font = UIFont(name: "Avenir Next", size: 27)
        {
            
            
            ms = NSMutableAttributedString(string: "Pull to refresh", attributes: [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.black])
            
        }
        refresherLabel = UILabel(frame: self.refresher.frame)
        refresherLabel.center.x = self.refresher.center.x
        refresherLabel.textAlignment = .center
        refresherLabel.layer.borderColor = UIColor.white.cgColor
        refresherLabel.backgroundColor = UIColor.clear
        refresherLabel.attributedText = ms
        refresherLabel.clipsToBounds = true
        self.refresher.tintColor = UIColor.clear
        self.refresher.addSubview(refresherLabel)
    }
    
    func resetRefresher()
    {
        
        self.refresher.backgroundColor = self.tableView.backgroundColor
        var ms = NSMutableAttributedString()
        if let font = UIFont(name: "Avenir Next", size: 27)
        {
            
            
            ms = NSMutableAttributedString(string: "Pull to refresh", attributes: [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.black])
            
        }
        self.refresherLabel.attributedText = ms
        self.refresherLabel.layer.transform = CATransform3DIdentity
        
    }
    
    func animateRefresher(colorIndex : Int)
    {
        
        if self.isRefresherAnimating == true
        {
        
            let cm = colorManager()
            
            var colorArray = [cm.colorRgb(red: 31, green: 161, blue: 204), cm.colorRgb(red: 99, green: 139, blue: 153), cm.colorRgb(red: 17, green: 255, blue: 185), cm.colorRgb(red: 252, green: 152, blue: 144), cm.colorRgb(red: 204, green: 10, blue: 59)]
            UIView.animate(withDuration: 0.3, animations: { 
                
                self.refresher.backgroundColor = colorArray[colorIndex]
                if let font = UIFont(name: "Avenir Next", size: 27)
                {
                    
                    self.refresherLabel.attributedText = NSMutableAttributedString(string: "Refreshing!", attributes: [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.white])
                    
                }
                if colorIndex%2 == 0
                {
                    
                    self.refresherLabel.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1)
                    
                }
                else
                {
                    
                    self.refresherLabel.layer.transform = CATransform3DIdentity
                    
                }
                
                }) { (success) in
                    
                    
                    if success == true
                    {
                        
                        self.animateRefresher(colorIndex : (colorIndex+1)%colorArray.count)
                        if self.refresher.isRefreshing == false
                        {
                            
                            self.isRefresherAnimating = true
                            self.resetRefresher()
                            
                        }
                        
                    }
            }
        }
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset : CGFloat = scrollView.contentOffset.y;
        let maximumOffset : CGFloat =  scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= scrollView.frame.height)
        {
            
            if Reachability.isConnectedToNetwork() == true && didScrollOnce == false && self.ids.count >= 20
            {
                
                self.navSpinner.startAnimating()
                self.didScrollOnce = true
                self.downloadNext(urlString: self.next20, completionHandler: { (success) in
                    
                    if success == true
                    {
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.saveData()
                            UIView.setAnimationsEnabled(false)
                            CATransaction.begin()
                            
                            
                            self.tableView.reloadData()
                            CATransaction.commit()
                            CATransaction.setCompletionBlock { () -> Void in
                                
                                UIView.setAnimationsEnabled(true)
                            }
                            self.navSpinner.stopAnimating()
                            self.didScrollOnce = false
                            
                        })

                        
                    }
                    else
                    {
                        
                        print("An error occurred")
                        self.navSpinner.stopAnimating()
                        self.didScrollOnce = false
                        
                    }
                
                })


            }
            
            if Reachability.isConnectedToNetwork() == false
            {
                
                print("Not connected to the internet")
                
            }
            
            
        }
        
    }
    
    func downloadNext(urlString : String, completionHandler : @escaping (_ success : Bool)->Void)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            
            let url = URL(string: urlString)
            let session = URLSession.shared
            let task = session.dataTask(with: url!) { (data, response, error) in
                
                if let error = error
                {
                    
                    print(error.localizedDescription)
                    completionHandler(false)
                    
                }
                else
                {
                    
                    if let data = data
                    {
                        
                        do
                        {
                            
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                            if let jsonData = jsonData as? [String:AnyObject]
                            {
                                
                                if let paging = jsonData["paging"] as? [String:AnyObject]
                                {
                                    
                                    if let next20 = paging["next"] as? String
                                    {
                                        
                                        self.next20 = next20
                                        
                                    }
                                    
                                }
                                if let items = jsonData["data"] as? [[String:AnyObject]]
                                {
                                    
                                    for item in items
                                    {
                                        
                                        if let id = item["id"] as? String
                                        {
                                            
                                            self.ids.append(id)
                                            
                                        }
                                        
                                        if let attachments = item["attachments"] as? [String:AnyObject]
                                        {
                                            self.attachments[(item["id"] as? String)!] = attachments
                                            if let attachmentData = attachments["data"] as? [[String:AnyObject]]
                                            {
                                                for x in attachmentData
                                                {
                                                    if let subattachments = x["subattachments"] as? [String:AnyObject]
                                                    {
                                                        if let subData = subattachments["data"] as? [[String:AnyObject]]
                                                        {
                                                            for y in subData
                                                            {
                                                                if let media = y["media"] as? [String:AnyObject]
                                                                {
                                                                    if let image = media["image"] as? [String:AnyObject]
                                                                    {
                                                                        if let src = image["src"] as? String
                                                                        {
                                                                            self.highResImageURLs[item["id"] as! String] = src
                                                                            break;
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        break;
                                                    }
                                                    else
                                                    {
                                                        break;
                                                    }
                                                    
                                                }
                                                
                                                for x in attachmentData
                                                {
                                                    
                                                    if let media = x["media"] as? [String:AnyObject]
                                                    {
                                                        if let image = media["image"] as? [String:AnyObject]
                                                        {
                                                            if let src = image["src"] as? String
                                                            {
                                                                
                                                                self.highResImageURLs[item["id"] as! String] = src
                                                                
                                                                
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                        }
                                        
                                        if let message = item["message"] as? String
                                        {
                                            
                                            self.messages.append(message)
                                            
                                        }
                                        else
                                        {
                                            
                                            self.messages.append("")
                                            
                                        }
                                        
                                        if let likes = item["likes"] as? [String:AnyObject]
                                        {
                                            
                                            if let summary = likes["summary"] as? [String:AnyObject]
                                            {
                                                
                                                if let totalCount = summary["total_count"] as? NSInteger
                                                {
                                                    
                                                    self.likes.append(totalCount)
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                        if let date = item["created_time"] as? String
                                        {
                                            
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                                            let newDate = dateFormatter.date(from: date)
                                            dateFormatter.dateFormat = "dd-MM-yyyy,HH:mm"
                                            dateFormatter.amSymbol = "AM"
                                            dateFormatter.pmSymbol = "PM"
                                            let dateString = dateFormatter.string(from: newDate!)
                                            self.dates.append(dateString)
                                            
                                        }
                                        
                                    }
                                    
                                    completionHandler(true)
                                    
                                }
                                
                            }
                            
                        }
                        catch
                        {
                            
                            print("JSON serialisation failed")
                            
                        }
                        
                    }
                    
                }
                
            }
            
            task.resume()

            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.ids.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let id = self.ids[indexPath.row]
        
        if let imurl = self.highResImageURLs[id]
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! ieeeFeedCell
            
            cell.layoutIfNeeded()
            cell.contentView.backgroundColor = UIColor.clear
            if self.messages[indexPath.row] != ""
            {
                cell.message.text = self.messages[indexPath.row]
            }
            else
            {
                cell.message.text = "No description available"
            }
            cell.date.text = self.dates[indexPath.row]
            cell.likes.text = String(self.likes[indexPath.row])
            cell.likes.textAlignment = .center
            cell.paddingView.clipsToBounds = true
            cell.paddingView.layer.cornerRadius = 4
            let path = UIBezierPath(rect: cell.paddingView.bounds)
            cell.shadowView.layer.shadowPath = path.cgPath
            cell.shadowView.layer.shadowPath = path.cgPath
            cell.shadowView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
            cell.shadowView.layer.shadowOpacity = 0.3
            let url = URL(string: imurl)
            cell.img.setShowActivityIndicator(true)
            cell.img.setIndicatorStyle(UIActivityIndicatorViewStyle.whiteLarge)
            cell.img.sd_setImage(with: url, completed: { (image, error, cache, url) in
                
            })
            
            return cell
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "noImageFeedCell", for : indexPath) as! ieeeNoImageFeedCell
        cell.layoutIfNeeded()
        if self.messages[indexPath.row] != ""
        {
            cell.message.text = self.messages[indexPath.row]
        }
        else
        {
            cell.message.text = "No description available"
        }
        cell.date.text = self.dates[indexPath.row]
        cell.likes.text = String(self.likes[indexPath.row])
        cell.likes.textAlignment = .center
        cell.paddingView.layer.cornerRadius = 4
        let path = UIBezierPath(rect: cell.paddingView.bounds)
        cell.paddingView.layer.shadowPath = path.cgPath
        cell.paddingView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        cell.paddingView.layer.shadowOpacity = 0.3
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let id = self.ids[indexPath.row]
        self.updateBlur()
        if self.highResImageURLs[id] != nil && self.messages[indexPath.row] == ""
        {
            
            self.browser = MWPhotoBrowser()
            photos.removeAll()
            photos.append(MWPhoto(url: URL(string: self.highResImageURLs[self.ids[indexPath.row]]!)))
            browser.delegate = self
            browser.enableSwipeToDismiss = true
            
            self.windowButton = UIButton(type: .system)
            
            self.present(browser, animated: true) {
                
                self.windowButton.frame = CGRect(x: self.view.bounds.width*0.85-30, y: 40, width: 60, height: 40)
                var s = NSMutableAttributedString()
                if let f = UIFont(name: "Avenir Book", size: 17)
                {
                    s = NSMutableAttributedString(string: "Done", attributes: [NSFontAttributeName : f])
                }
                self.windowButton.setAttributedTitle(s, for: .normal)
                self.windowButton.addTarget(self, action: #selector(feedTableView.dismissBrowser), for: .touchUpInside)
                if let window = UIApplication.shared.delegate?.window
                {
                    window?.addSubview(self.windowButton)
                }
            }
            return
            
        }
        
        if self.highResImageURLs[id] != nil
        {
            
            
            let imurl = self.highResImageURLs[id]
            
            let feedPage = SDInstantArticleViewController()
            feedPage.screenshot = self.screenshot
            feedPage.passAttachments = self.attachments[id]!
            feedPage.passHighResImageURL = imurl!
            feedPage.passMessage = self.messages[indexPath.row]
            present(feedPage, animated: true, completion: nil)
            return
            
        }
        
        let noImageFeedPage = noImageFeedPageTest()
        noImageFeedPage.passMessage = self.messages[indexPath.row]
        noImageFeedPage.screenshot = self.screenshot
        self.present(noImageFeedPage, animated: true, completion: nil)
    }
    
    //MARK : MWPhotobrowserDelegate methods
    
    func dismissBrowser()
    {
        self.windowButton.removeFromSuperview()
        self.browser.dismiss(animated: true) {
            
        }
    }
    
    func updateBlur()
    {

        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.view.bounds.width, height: self.view.bounds.height), true, 1)
        self.view.drawHierarchy(in: self.view.layer.frame, afterScreenUpdates: false)
        screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
    }
    
    internal func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt
    {
        
        return UInt(self.photos.count)
        
    }
    
    internal func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol!
    {
        
        return self.photos[Int(index)]
        
    }
    

    
}
