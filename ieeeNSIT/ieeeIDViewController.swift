//
//  ieeeIDViewController.swift
//  ieeeNSIT
//
//  Created by Swapnil Dhanwal on 28/01/17.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class ieeeIDViewController: UIViewController, UITextFieldDelegate {
    
    var welcome : welcomeView!
    var loginView : UIView!
    var loginLabel : UILabel!
    var loginTextField : UITextField!
    var doneView : UIView!
    var doneButton : UIButton!
    var go : Bool!
    var spinner = UIActivityIndicatorView()
    var phoneNumber = String()
    var nameLabel = UILabel()
    var branchLabel = UILabel()
    var membershipLabel = UILabel()
    var watermarkImageView = UIImageView()
    var notFoundTextView = UITextView()
    var backButton = UIButton()
    var array : [String : AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "array") == nil
        {
            
            let welcomeFrame = CGRect(x: self.view.bounds.width/2-self.view.bounds.width*0.75/2, y: self.view.bounds.height/2 - self.view.bounds.height*0.5/2-20, width: self.view.bounds.width*0.75, height: self.view.bounds.height*0.5)
            welcome = welcomeView(welcomeFrame, ["Hi.\nThis is your\nIEEE ID.", "Show this at IEEE NSIT events to gain access."], getColor(red: 61, green: 78, blue: 245), UIColor.white, UIColor.white, {
                
                self.configureLoginView()
                self.loginView.alpha = 0
                self.loginView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    
                    self.loginView.alpha = 1
                    self.loginView.layer.setAffineTransform(CGAffineTransform.identity)
                    
                    
                }, completion: { (success) in
                    
                    
                    
                })
                
                
            })
            welcome.textAlignment = NSTextAlignment.left
            welcome.showShadow = true
            self.view.addSubview(welcome)

            
        }
        else
        {
            //resize loginView
            self.loginView = UIView()
            self.loginView.frame = CGRect(x: self.view.bounds.width*0.1, y: self.view.bounds.height*0.1-20, width: self.view.bounds.width*0.8, height: self.view.bounds.height*0.8)
            let path = UIBezierPath(roundedRect: self.loginView.bounds, cornerRadius: 10)
            self.loginView.layer.shadowPath = path.cgPath
            self.loginView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
            self.loginView.layer.shadowOpacity = 0.3
            self.loginView.backgroundColor = getColor(red: 61, green: 78, blue: 245)
            self.loginView.layer.cornerRadius = 10
            self.array = UserDefaults.standard.object(forKey: "array") as? [String : AnyObject]
            self.loginView.alpha = 0
            self.loginView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
            self.view.addSubview(self.loginView)
            self.showID()
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                
                self.loginView.alpha = 1
                self.loginView.layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
                
            }, completion: { (success) in
                
                
            })
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func configureLoginView()
    {
        
        if self.loginView != nil
        {
            
            for view in self.loginView.subviews
            {
                
                view.removeFromSuperview()
                
            }
            
        }
        
        //configure login view
        self.loginView = UIView(frame: CGRect(x: self.view.bounds.width/2-self.view.bounds.width*0.75/2, y: self.view.bounds.height/2-self.view.bounds.height*0.5/2, width: self.view.bounds.width*0.75, height: self.view.bounds.height*0.5))
        self.loginView.backgroundColor = getColor(red: 61, green: 78, blue: 245)
        self.loginView.layer.cornerRadius = 10
        let path = UIBezierPath(roundedRect: self.loginView.bounds, cornerRadius: 10)
        self.loginView.layer.shadowPath = path.cgPath
        self.loginView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.loginView.layer.shadowOpacity = 0.3
        
        //configure login label
        self.loginLabel = UILabel(frame: CGRect(x: self.loginView.bounds.width*0.1, y: 0, width: self.loginView.bounds.width*0.8, height: self.loginView.bounds.height*0.8))
        self.loginLabel.text = "Please enter your registered mobile number."
        self.loginLabel.font = UIFont(name: "Avenir Book", size: 30)
        self.loginLabel.numberOfLines = -1
        self.loginLabel.textColor = UIColor.white
        self.loginLabel.textAlignment = .left
        self.loginView.addSubview(self.loginLabel)
        
        //configure loginTextField
        self.loginTextField = UITextField(frame: CGRect(x: self.loginView.bounds.width*0.1, y: self.loginLabel.bounds.maxY, width: self.loginView.bounds.width*0.8, height: 30))
        self.loginView.addSubview(self.loginTextField)
        self.loginTextField.backgroundColor = UIColor.white
        self.loginTextField.layer.cornerRadius = 10
        self.loginTextField.keyboardType = .phonePad
        self.loginTextField.textAlignment = .center
        self.loginTextField.font = UIFont(name: "Avenir Book", size: 20)
        
        self.view.addSubview(self.loginView)
        
        //configure doneView and doneButton
        self.doneView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.loginView.bounds.height*0.2))
        self.doneView.alpha = 0
        self.doneView.backgroundColor = UIColor.white
        self.view.addSubview(self.doneView)
        
        self.doneButton = UIButton(type: .roundedRect)
        self.doneButton.frame = CGRect(x: self.doneView.bounds.width-5-self.doneView.bounds.width*0.3, y: self.doneView.bounds.height*0.15, width: self.doneView.bounds.width*0.3, height: self.doneView.bounds.height*0.7)
        self.doneButton.addTarget(self, action: #selector(ieeeIDViewController.done), for: .touchUpInside)
        self.doneButton.backgroundColor = getColor(red: 61, green: 78, blue: 245)
        self.doneButton.layer.cornerRadius = 5
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            let s = NSMutableAttributedString(string: "Go", attributes: [NSFontAttributeName : f, NSForegroundColorAttributeName : UIColor.white])
            self.doneButton.setAttributedTitle(s, for: .normal)
            
        }
        self.go = false
        self.doneView.addSubview(self.doneButton)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ieeeIDViewController.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ieeeIDViewController.keyboardWillDisappear(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(_ notification : NSNotification)
    {
        
        //move loginView up
        let keyBoardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let tf = self.loginView.convert(self.loginTextField.frame, to: self.view)
        
        self.doneView.frame = CGRect(x: 0, y: keyBoardFrame.minY-self.loginView.bounds.height*0.2, width: self.view.bounds.width, height: self.loginView.bounds.height*0.2)
        self.doneView.alpha = 0
        self.doneView.backgroundColor = UIColor.white
        
        
        if (tf.maxY > keyBoardFrame.minY)
        {
            

            UIView.animate(withDuration: 0.4) {
                
                self.doneView.layer.setAffineTransform(CGAffineTransform.identity)
                self.doneView.alpha = 1

                let dy = tf.maxY - keyBoardFrame.minY + 30 + self.doneView.frame.height
                self.loginView.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: -dy))
                
            }
            
        }
        
        
    }
    
    func done()
    {
        
        if (self.loginTextField.text?.characters.count)! > 0
        {
            
            self.go = true
            self.phoneNumber = self.loginTextField.text!
            self.loginTextField.resignFirstResponder()
            
            
        }
        else if (self.loginTextField.text?.characters.count)! == 0
        {
            
            self.showAlert("Please enter a valid phone number")
            
        }
        
    }
    
    
    
    func keyboardWillDisappear(_ notification : NSNotification)
    {
        
        if self.go == false
        {
            UIView.animate(withDuration: 0.4, animations: {
                
                self.doneView.alpha = 0
                self.loginView.layer.setAffineTransform(CGAffineTransform.identity)
                
            }) { (success) in
                
                //do something
                
            }
        }
        else
        {
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.doneView.alpha = 0
                self.loginView.layer.setAffineTransform(CGAffineTransform.identity)
                
            }) { (success) in
                
                
                print("load data now")
                //prepare login view for loading data 
                for view in self.loginView.subviews
                {
                    
                    view.removeFromSuperview()
                    
                }
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { 
                    
                    self.configureID()
                    
                }, completion: { (success) in
                    
                    
                    
                })
                
            }
            
        }
        
    }
    
    func configureID()
    {
        
        //resize loginView
        self.loginView.frame = CGRect(x: self.view.bounds.width*0.1, y: self.view.bounds.height*0.1-20, width: self.view.bounds.width*0.8, height: self.view.bounds.height*0.8)
        let path = UIBezierPath(roundedRect: self.loginView.bounds, cornerRadius: 10)
        self.loginView.layer.shadowPath = path.cgPath
        self.loginView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.loginView.layer.shadowOpacity = 0.3
        
        //configure spinner
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.spinner.center = CGPoint(x: self.loginView.bounds.width/2, y: self.loginView.bounds.height/2)
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        self.spinner.color = UIColor.white
        self.loginView.addSubview(self.spinner)
        
        //download the data 
        getData { (user, success) in
            
            if (success == true)
            {
                //save object to Userdefaults.standard
                self.array = user
                UserDefaults.standard.set(self.array, forKey : "array")
                
                //stop spinner without animation
                UIView.setAnimationsEnabled(false)
                CATransaction.begin()
                self.spinner.stopAnimating()
                CATransaction.commit()
                CATransaction.setCompletionBlock({
                    
                    UIView.setAnimationsEnabled(true)
                    
                })
                self.showID()
                
            }
            else
            {
                //stop spinner without animation
                UIView.setAnimationsEnabled(false)
                CATransaction.begin()
                self.spinner.stopAnimating()
                CATransaction.commit()
                CATransaction.setCompletionBlock({ 
                    
                    UIView.setAnimationsEnabled(true)
                    self.showMailInfo()
                    
                })
                //show options to mail ieee nsit
                
            }
        }
        
        
    }
    
    func showID()
    {
        
        if let user = self.array
        {
            
            if let _name = user["NAME"] as? String
            {
                
                if let _branch = user["BRANCH"] as? String
                {
                    
                    if let payment = user["PAYMENT"] as? Int
                    {
                        var p : String!
                        switch payment {
                        case 2400:
                            p = "IEEE WIE CS"
                        case 1900:
                            p = "IEEE WIE"
                        default:
                            p = "Due"
                        }
                        
                        //configure watermark
                        self.watermarkImageView = UIImageView(frame: CGRect(x: self.loginView.bounds.width/2-self.loginView.bounds.width*0.90/2, y: self.loginView.bounds.height/2-self.loginView.bounds.height*0.75/2, width: self.loginView.bounds.width*0.90, height: self.loginView.bounds.height*0.75))
                        self.watermarkImageView.image = UIImage(named: "ieeeWatermark.png")
                        self.watermarkImageView.contentMode = .scaleAspectFit
                        self.loginView.addSubview(self.watermarkImageView)
                        
                        //add ieee label
                        let ieeeLabel = UILabel(frame: CGRect(x: self.loginView.bounds.width*0.1, y: 0, width: self.loginView.bounds.width*0.8, height: self.loginView.bounds.height*0.1))
                        ieeeLabel.font = UIFont(name: "Avenir Book", size: 25)
                        ieeeLabel.textColor = UIColor.white
                        ieeeLabel.text = "IEEE ID"
                        ieeeLabel.textAlignment = .center
                        self.loginView.addSubview(ieeeLabel)
                        
                        //fix label height
                        let y = (self.loginView.bounds.height-ieeeLabel.bounds.height)/3
                        let dy = y*0.1
                        let fy = y - 2*dy; //this is the height of a label
                        
                        //configure name label
                        self.nameLabel = UILabel(frame: CGRect(x: self.loginView.bounds.width*0.1, y: ieeeLabel.bounds.height+0, width: self.loginView.bounds.width*0.8, height: fy/2))
                        self.nameLabel.text = "Name:"
                        self.nameLabel.numberOfLines = -1
                        self.nameLabel.font = UIFont(name: "Avenir Book", size: 20)
                        self.nameLabel.textColor = UIColor.white
                        self.nameLabel.backgroundColor = UIColor.clear
                        self.loginView.addSubview(self.nameLabel)
                        let name = UILabel(frame: CGRect(x: self.loginView.bounds.width*0.1, y: ieeeLabel.bounds.height+fy/2, width: self.loginView.bounds.width*0.8, height: fy/2))
                        name.textColor = getColor(red: 61, green: 78, blue: 245)
                        let n = _name.capitalized
                        name.text = " \(n)"
                        name.backgroundColor = UIColor.white
                        name.adjustsFontSizeToFitWidth = true
                        name.layer.masksToBounds = false
                        var roundedCornerLayer = CAShapeLayer()
                        roundedCornerLayer.path = UIBezierPath(roundedRect: name.bounds, cornerRadius: 15).cgPath
                        name.layer.mask = roundedCornerLayer
                        name.layer.cornerRadius = 15
                        name.font = UIFont(name: "Avenir Book", size: 20)
                        var path = UIBezierPath(roundedRect: name.bounds, cornerRadius: 15)
                        name.layer.shadowPath = path.cgPath
                        name.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
                        name.layer.shadowOpacity = 0.3
                        let shadowName = UIView(frame: name.frame)
                        shadowName.backgroundColor = UIColor.clear
                        shadowName.layer.shadowOpacity = 0.3
                        shadowName.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
                        self.loginView.insertSubview(shadowName, at: 0)
                        self.loginView.addSubview(name)
                        
                        //configure branch label
                        self.branchLabel = UILabel(frame: CGRect(x: self.loginView.bounds.width*0.1, y: ieeeLabel.bounds.height+fy+2*dy, width: self.loginView.bounds.height*0.8, height: fy/2))
                        self.branchLabel.text = "Branch:"
                        self.branchLabel.numberOfLines = -1
                        self.branchLabel.font = UIFont(name: "Avenir Book", size: 20)
                        self.branchLabel.textColor = UIColor.white
                        self.branchLabel.backgroundColor = UIColor.clear
                        self.loginView.addSubview(self.branchLabel)
                        let branch = UILabel(frame: CGRect(x: self.loginView.bounds.width*0.1, y: ieeeLabel.bounds.height+fy+fy/2+2*dy, width: self.loginView.bounds.width*0.8, height: fy/2))
                        branch.textColor = getColor(red: 61, green: 78, blue: 245)
                        let b = _branch.uppercased()
                        branch.text = " \(b)"
                        branch.backgroundColor = UIColor.white
                        roundedCornerLayer = CAShapeLayer()
                        roundedCornerLayer.path = UIBezierPath(roundedRect: branch.bounds, cornerRadius: 15).cgPath
                        branch.layer.mask = roundedCornerLayer
                        branch.layer.cornerRadius = 15
                        branch.font = UIFont(name: "Avenir Book", size: 20)
                        path = UIBezierPath(roundedRect: branch.bounds, cornerRadius: 15)
                        branch.layer.shadowPath = path.cgPath
                        branch.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
                        branch.layer.shadowOpacity = 0.3
                        self.loginView.addSubview(branch)
                        
                        //configure membership label
                        self.membershipLabel = UILabel(frame: CGRect(x: self.loginView.bounds.width*0.1, y: ieeeLabel.bounds.height+2*fy+4*dy, width: self.loginView.bounds.height*0.8, height: fy/2))
                        self.membershipLabel.text = "Membership:"
                        self.membershipLabel.numberOfLines = -1
                        self.membershipLabel.font = UIFont(name: "Avenir Book", size: 20)
                        self.membershipLabel.textColor = UIColor.white
                        self.membershipLabel.backgroundColor = UIColor.clear
                        self.loginView.addSubview(self.membershipLabel)
                        
                        let membership = UILabel(frame: CGRect(x: self.loginView.bounds.width*0.1, y: ieeeLabel.bounds.height+2*fy+fy/2+4*dy, width: self.loginView.bounds.width*0.8, height: fy/2))
                        membership.textColor = getColor(red: 61, green: 78, blue: 245)
                        membership.text = " \(p!)"
                        membership.backgroundColor = UIColor.white
                        roundedCornerLayer = CAShapeLayer()
                        roundedCornerLayer.path = UIBezierPath(roundedRect: membership.bounds, cornerRadius: 15).cgPath
                        membership.layer.mask = roundedCornerLayer
                        membership.layer.cornerRadius = 15
                        membership.font = UIFont(name: "Avenir Book", size: 20)
                        path = UIBezierPath(roundedRect: membership.bounds, cornerRadius: 15)
                        membership.layer.shadowPath = path.cgPath
                        membership.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
                        membership.layer.shadowOpacity = 0.3
                        self.loginView.addSubview(membership)

                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    func showMailInfo()
    {
        
        //change loginView frame
        self.loginView.frame = CGRect(x: self.view.bounds.width/2-self.view.bounds.width*0.75/2, y: self.view.bounds.height/2-self.view.bounds.height*0.6/2, width: self.view.bounds.width*0.75, height: self.view.bounds.height*0.6)
        let path = UIBezierPath(roundedRect: self.loginView.bounds, cornerRadius: 10)
        self.loginView.layer.shadowPath = path.cgPath
        self.loginView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.loginView.layer.shadowOpacity = 0.3
        
        //configure watermark
        self.watermarkImageView = UIImageView(frame: CGRect(x: self.loginView.bounds.width/2-self.loginView.bounds.width*0.90/2, y: self.loginView.bounds.height/2-self.loginView.bounds.height*0.75/2, width: self.loginView.bounds.width*0.90, height: self.loginView.bounds.height*0.75))
        self.watermarkImageView.image = UIImage(named: "ieeeWatermark.png")
        self.watermarkImageView.contentMode = .scaleAspectFit
        self.loginView.addSubview(self.watermarkImageView)
        
        //configure label
        self.notFoundTextView = UITextView(frame : CGRect(x: self.loginView.bounds.width*0.05, y: self.loginView.bounds.width*0.1, width: self.loginView.bounds.width*0.9, height: self.loginView.bounds.height*0.6))
        self.notFoundTextView.text = "Seems like you're not registered in our database.\nContact us at ieeensit@gmail.com for payment information"
        self.notFoundTextView.textColor = UIColor.white
        self.notFoundTextView.textAlignment = .left
        self.notFoundTextView.dataDetectorTypes = .all
        self.notFoundTextView.backgroundColor = UIColor.clear
        self.notFoundTextView.isEditable = false
        self.notFoundTextView.isScrollEnabled = false
        self.notFoundTextView.linkTextAttributes = [NSUnderlineStyleAttributeName :
            NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName : UIColor.white]
        self.notFoundTextView.font = UIFont(name: "Avenir Book", size: 25)
        self.loginView.addSubview(notFoundTextView)
        
        //configure backButton
        self.backButton = UIButton(type: .roundedRect)
        self.backButton.frame = CGRect(x: self.loginView.bounds.width*0.2, y: self.notFoundTextView.frame.maxY + 0.3*(self.loginView.bounds.height-self.notFoundTextView.bounds.height), width: self.loginView.bounds.width*0.6, height: 0.4*(self.loginView.bounds.height-self.notFoundTextView.bounds.height))
        self.backButton.backgroundColor = UIColor.white
        self.backButton.layer.cornerRadius = 5
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
         
            let s = NSMutableAttributedString(string: "Back", attributes: [NSFontAttributeName : f, NSForegroundColorAttributeName : getColor(red: 61, green: 78, blue: 245)])
            self.backButton.setAttributedTitle(s, for: .normal)
            
        }
        self.backButton.addTarget(self, action: #selector(ieeeIDViewController.back), for: .touchUpInside)
        self.loginView.addSubview(self.backButton)
        
    }
    
    func back()
    {
        if self.loginView != nil
        {
            
            self.loginView.removeFromSuperview()
            
        }
        self.configureLoginView()
        self.loginView.alpha = 0
        self.loginView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            
            self.loginView.alpha = 1
            self.loginView.layer.setAffineTransform(CGAffineTransform.identity)
            
            
        }, completion: { (success) in
            
            //do something
            
        })
        
    }
    
    func getData(completion : @escaping (_ user : [String : AnyObject], _ success : Bool) -> Void)
    {
        
        let url = URL(string : "http://ieeensit.org/ieeemembers.json")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error
            {
                DispatchQueue.main.async(execute: { 
                    
                    self.showAlert("\(error.localizedDescription)")
                    completion([:], false)
                    
                })
                
            }
            else
            {
                DispatchQueue.main.async(execute: { 
                    
                    if let data = data
                    {
                        
                        do
                        {
                            
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                            if let data = jsonData?["data"] as? [[String : AnyObject]]
                            {
                                
                                for item in data
                                {
                                    
                                    if let phone = item["Phone 1 - Value"] as? Int
                                    {
                                        
                                        print (phone)
                                        print (self.phoneNumber)
                                        //do something
                                        if (Int(self.phoneNumber) == (phone))
                                        {
                                            
                                            completion(item, true)
                                            return
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                completion([:], false)
                            }
                            
                        }
                        catch
                        {
                            
                            
                            
                        }
                        
                    }

                    
                })
                
            }
            
        }
        task.resume()
    }
    
    func showAlert(_ errorString : String)
    {
        
        let alert = UIAlertController(title: "An Error Occurred", message: "\(errorString)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            
            
        }))
        self.present(alert, animated: true) { 
            
            
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.loginTextField.resignFirstResponder()
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if loginView != nil && loginTextField != nil
        {
            self.loginTextField.resignFirstResponder()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "go"
        {
            
            print("value changed to \(self.go)")
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
