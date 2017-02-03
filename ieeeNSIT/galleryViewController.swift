//
//  ViewController.swift
//  collectionView
//
//  Created by Swapnil Dhanwal on 31/01/17.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit
import IDMPhotoBrowser
import SDWebImage

class galleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, IDMPhotoBrowserDelegate {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    var headerView : UIView!
    var headerLabel : UILabel!
    var blurView : UIVisualEffectView!
    var smallImageURLS = [String]()
    var likes = [NSInteger]()
    var highResImageURLs = [String]()
    var spinner = UIActivityIndicatorView()
    var retryButton = UIButton()
    var count = Int()
    var _photos = [IDMPhoto]()
    var windowButton = UIButton()
    var photoIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureHeaderView()
        
        self.count = 0
        self.photoIndex = 0
                
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.spinner.center = self.view.center
        self.spinner.hidesWhenStopped = true
        self.spinner.color = getColor(red: 61, green: 78, blue: 245)
        self.view.addSubview(self.spinner)
        self.spinner.startAnimating()
        
        self.retryButton = UIButton(type: .custom)
        self.retryButton.frame = CGRect(x: self.view.bounds.width/2-50, y: self.view.bounds.height/2-50, width: 100, height: 100)
        self.retryButton.setImage(UIImage(named : "refresh.png"), for: .normal)
        self.view.addSubview(self.retryButton)
        self.retryButton.alpha = 0
        self.retryButton.addTarget(self, action: #selector(galleryViewController.retry), for: .touchUpInside)
        
        let url = "https://graph.facebook.com/v2.5/176108879110422/photos?fields=name,likes.summary(true),images,source&access_token=CAAGZAwVFNCKgBAANhEYok6Xh7Q7UZBeTZCUqwPDLYhRZCmNn0igI8SE339jSn2zjxCpA1JUmXHm55XKVXslhdKKoTF3b5sLsiZBVd0ylYwX3MIGOnRyzn0T2XVywwoPKP7ML9WZCqELGRuIGxoM8ia05CiUiqcbgsb4wzTuBKkvKaqb7TPt2VnPtprRZBWda4kZD"
        self.downloadData(urlString: url) { (array, success, error) in
            
            if success == true
            {
                
                self.count = array.count
                for item in array
                {
                    
                    //get number of likes
                    if let likes = item["likes"] as? [String : AnyObject]
                    {
                        
                        if let summary = likes["summary"] as? [String : AnyObject]
                        {
                            
                            if let total_count = summary["total_count"] as? Int
                            {
                                
                                self.likes.append(total_count)
                                
                            }
                            
                        }
                        
                    }
                    
                    //get small image URL
                    if let images = item["images"] as? [[String : AnyObject]]
                    {
                        
                        for image in images
                        {
                            
                            if let height = image["height"] as? NSInteger
                            {
                                
                                if height <= 320
                                {
                                    //found 320x320 or less
                                    if let source = image["source"] as? String
                                    {
                                        
                                        self.smallImageURLS.append(source)
                                        break;
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    //get high res image URL
                    if let source = item["source"] as? String
                    {
                        let photo = IDMPhoto(url: URL(string: source))
                        if let name = item["name"] as? String
                        {
                            
                            photo?.caption = name
                            
                        }
                        self._photos.append(photo!)
                        self.highResImageURLs.append(source)
                        
                    }
                }
                self.view.addSubview(self.headerView)
                self.configureCollectionView {
                    
                    self.spinner.stopAnimating()
                    self.galleryCollectionView.reloadData()
                    
                }
                
            }
            else
            {
                
                self.showAlert(errorString: error.localizedDescription, completionHandler: {
                    
                    //do something
                    self.spinner.stopAnimating()
                    self.retryButton.alpha = 1
                    
                })
                
            }
            
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func retry()
    {
        
        self.retryButton.alpha = 0
        self.spinner.startAnimating()
        self.headerView.removeFromSuperview()
        if galleryCollectionView != nil
        {
            self.galleryCollectionView.removeFromSuperview()
        }
        
        let url = "https://graph.facebook.com/v2.5/176108879110422/photos?fields=name,likes.summary(true),images,source&access_token=CAAGZAwVFNCKgBAANhEYok6Xh7Q7UZBeTZCUqwPDLYhRZCmNn0igI8SE339jSn2zjxCpA1JUmXHm55XKVXslhdKKoTF3b5sLsiZBVd0ylYwX3MIGOnRyzn0T2XVywwoPKP7ML9WZCqELGRuIGxoM8ia05CiUiqcbgsb4wzTuBKkvKaqb7TPt2VnPtprRZBWda4kZD"
        self.downloadData(urlString: url) { (array, success, error) in
            
            if success == true
            {
                
                self.count = array.count
                for item in array
                {
                    
                    //get number of likes
                    if let likes = item["likes"] as? [String : AnyObject]
                    {
                        
                        if let summary = likes["summary"] as? [String : AnyObject]
                        {
                            
                            if let total_count = summary["total_count"] as? Int
                            {
                                
                                self.likes.append(total_count)
                                
                            }
                            
                        }
                        
                    }
                    
                    //get small image URL
                    if let images = item["images"] as? [[String : AnyObject]]
                    {
                        
                        for image in images
                        {
                            
                            if let height = image["height"] as? NSInteger
                            {
                                
                                if height <= 320
                                {
                                    //found 320x320 or less
                                    if let source = image["source"] as? String
                                    {
                                        
                                        self.smallImageURLS.append(source)
                                        break;
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    //get high res image URL
                    if let source = item["source"] as? String
                    {
                        
                        let photo = IDMPhoto(url: URL(string: source))
                        if let name = item["name"] as? String
                        {
                            
                            photo?.caption = name
                            
                        }
                        self._photos.append(photo!)
                        self.highResImageURLs.append(source)
                        
                    }
                }
                print(self.likes.count)
                self.view.addSubview(self.headerView)
                self.configureCollectionView {
                    
                    self.spinner.stopAnimating()
                    self.galleryCollectionView.reloadData()
                    
                }
                
            }
            else
            {
                
                self.showAlert(errorString: error.localizedDescription, completionHandler: {
                    
                    //do something
                    self.spinner.stopAnimating()
                    self.retryButton.alpha = 1
                    
                })
                
            }
            
        }

        
    }
    
    func configureHeaderView()
    {
        
        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 75))
        self.headerView.backgroundColor = UIColor.clear
        let blur = UIBlurEffect(style: .light)
        self.blurView = UIVisualEffectView(effect: blur)
        self.blurView.frame = self.headerView.bounds
        self.headerView.addSubview(self.blurView)
        self.headerLabel = UILabel(frame: self.headerView.bounds)
        self.headerLabel.font = UIFont(name: "Avenir Book", size: 27)
        self.headerLabel.text = "GALLERY"
        self.headerLabel.backgroundColor = UIColor.clear
        self.headerLabel.textAlignment = .center
        self.headerView.addSubview(self.headerLabel)
        
    }
    
    func configureCollectionView(completion : @escaping () -> Void)
    {
        
        if self.galleryCollectionView != nil
        {
            
            //set up collectionView
            self.galleryCollectionView.dataSource = self
            self.galleryCollectionView.delegate = self
            self.galleryCollectionView.contentInset.bottom = 49
            self.galleryCollectionView.contentInset.left = 10
            self.galleryCollectionView.contentInset.right = 10
            self.galleryCollectionView.contentInset.top = self.headerView.frame.maxY
            completion()

            
        }
        
    }
    
    func downloadData(urlString : String, completionHandler : @escaping(_ images : [[String:AnyObject]], _ success : Bool, _ error : Error) -> Void)
    {
        
        let url = URL(string : urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error
            {
                DispatchQueue.main.async(execute: {
                    
                    completionHandler([], false, error)
                    
                })
                
            }
            else
            {
                
                if let data = data
                {
                    
                    DispatchQueue.main.async(execute: {
                        
                        do
                        {
                            
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                            if let data = jsonData?["data"] as? [[String : AnyObject]]
                            {
                                
                                let nerror = NSError(domain: "Great", code: 10, userInfo: nil)
                                completionHandler(data, true, nerror as Error)
                                
                            }
                            
                        }
                        catch
                        {
                            
                            print("JSON Serialisation Failed")
                            
                            completionHandler([], false, error)
                            
                        }
                        
                    })
                    
                }
                
            }
            
        }
        task.resume()
        
    }
    
    func showAlert(errorString : String, completionHandler : @escaping () -> Void)
    {
        
        let alert = UIAlertController(title: "An Error Occurred", message: errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            //do something
            completionHandler()

            
        }))
        self.present(alert, animated: true) {
            
            
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return self.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = self.galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for view in cell.subviews
        {
            view.removeFromSuperview()
        }
        
        let paddingView = UIView(frame: CGRect(x: 0.05*cell.bounds.width, y: 0.05*cell.bounds.height, width: 0.9*cell.bounds.width, height: 0.9*cell.bounds.width))
        paddingView.backgroundColor = UIColor.groupTableViewBackground
        paddingView.clipsToBounds = true
        paddingView.layer.cornerRadius = 5
        
        let shadowView = UIView(frame: paddingView.frame)
        shadowView.backgroundColor = UIColor.clear
        let path = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 5)
        shadowView.layer.shadowPath = path.cgPath
        shadowView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        shadowView.layer.shadowOpacity = 0.3
        
        let thumbnail = UIImageView(frame: CGRect(x: 0, y: 0, width: paddingView.bounds.width, height: paddingView.bounds.height*0.75))
        thumbnail.backgroundColor = getColor(red: 61, green: 78, blue: 245)
        thumbnail.clipsToBounds = true
        thumbnail.setIndicatorStyle(.whiteLarge)
        thumbnail.setShowActivityIndicator(true)
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.sd_setImage(with: URL(string : self.smallImageURLS[indexPath.row]))
        paddingView.addSubview(thumbnail)
        
        let heart = UIImageView(frame: CGRect(x: 0.05*paddingView.bounds.width, y: (0.75+0.0625)*paddingView.bounds.height, width: 0.125*paddingView.bounds.height, height: 0.125*paddingView.bounds.height))
        heart.image = UIImage(named: "heart.png")
        paddingView.addSubview(heart)
        
        let like = UILabel(frame: CGRect(x: 0.65*paddingView.bounds.width, y: (0.75+0.0625)*paddingView.bounds.height, width: 0.3*paddingView.bounds.width, height: 0.125*paddingView.bounds.height))
        like.text = "\(self.likes[indexPath.row])"
        like.font = UIFont(name: "Avenir Book", size: 15)
        like.textAlignment = .right
        paddingView.addSubview(like)
        
        let line = UILabel(frame: CGRect(x: 0, y: thumbnail.frame.maxY, width: paddingView.bounds.width, height: 2))
        line.backgroundColor = getColor(red: 61, green: 78, blue: 245)
        paddingView.addSubview(line)
        
        cell.addSubview(shadowView)
        cell.addSubview(paddingView)
        
        
        
        return cell
        
    }
    
    
    //MARK : Delegate methods for IDMPhotoBrowser
    
    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser!, captionViewForPhotoAt index: UInt) -> IDMCaptionView!
    {
        
        let photo = self._photos[self.photoIndex]
        let captionView = BlurCaptionView(photo: photo)
        return captionView
        
    }
    
    
    //MARK : Delegate methods for Collection View
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: self.view.bounds.width/2*0.90, height: self.view.bounds.width/2*0.90)
        
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let _browser = IDMPhotoBrowser(photos: [self._photos[indexPath.row]])
        _browser?.delegate = self
        self.photoIndex = indexPath.row
        _browser?.usePopAnimation = true
        self.present(_browser!, animated: true, completion: nil)
        
        
    }
    

}

