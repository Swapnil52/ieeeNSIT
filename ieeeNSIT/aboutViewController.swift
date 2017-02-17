//
//  aboutViewController.swift
//  ieeeNSIT
//
//  Created by Swapnil Dhanwal on 09/02/17.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class aboutViewController: UIViewController {
    
    var mainView = UIView()
    var nameLabel = UILabel()
    var textView = UITextView()
    var watermarkImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureMainView()
        
        // Do any additional setup after loading the view.
    }
    
    func configureMainView()
    {
        
        //configure the mainView
        self.mainView = UIView(frame: CGRect(x: 0.05*self.view.bounds.width, y: 0.07*self.view.bounds.height, width: 0.9*self.view.bounds.width, height: 0.83*self.view.bounds.height))
//        self.mainView.backgroundColor = UIColor.groupTableViewBackground
        self.mainView.backgroundColor = getColor(red: 61, green: 78, blue: 245)
        self.mainView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.mainView.layer.shadowOpacity = 0.4
        self.mainView.layer.cornerRadius = 10
        self.view.addSubview(self.mainView)
        
        //configure the label
        self.nameLabel = UILabel(frame: CGRect(x: 0.05*self.mainView.bounds.width, y: 0, width: 0.9*self.mainView.bounds.width, height: 0.1*self.mainView.bounds.height))
        self.nameLabel.font = UIFont(name: "Avenir Book", size: 25)
//        self.nameLabel.textColor = getColor(red: 61, green: 78, blue: 245)
        self.nameLabel.textColor = UIColor.white
        self.nameLabel.text = "About us"
        self.mainView.addSubview(self.nameLabel)
        
        //configure the textView
        self.textView = UITextView(frame: CGRect(x: 0.01*self.mainView.bounds.width, y: self.nameLabel.bounds.maxY, width: 0.98*self.mainView.bounds.width, height:(self.mainView.bounds.height - self.nameLabel.bounds.height)-10))
        self.textView.font = UIFont(name: "Avenir Book", size: 18)
        self.textView.text = "Started back in 2001, IEEE-DIT has now grown into a multi faceted chapter, empowering young engineers to enhance their skills and setup milestones in the history of IEEE NSIT. Our foremost objective is to create an environment which promotes students to learn technical knowledge, inculcate managerial skills and develop their overall personalities. We achieve this by sponsoring technical projects, providing opportunities to manage and organize events and to participate at various events and conferences at state as well as national level. IEEE-NSIT Student Branch works to create an atmosphere of technical excellence for the students. It aims at helping students in building an aptitude towards applying engineering in daily life by learning ways to use the latest technology on offer.\n\n Dr (Prof) Prerna Gaur is the IEEE Delhi Section Secretary and serves as the Student Branch Counsellor for IEEE NSIT."
        self.textView.backgroundColor = UIColor.clear
//        self.textView.textColor = getColor(red: 37, green: 55, blue: 50)
        self.textView.textColor = UIColor.white
        self.mainView.addSubview(self.textView)
        
        //configure the watermark image view
        self.watermarkImageView = UIImageView(frame: CGRect(x: self.mainView.bounds.width/2-self.mainView.bounds.width*0.7/2, y: self.mainView.bounds.height/2 - self.mainView.bounds.height*0.7/2, width: self.mainView.bounds.width*0.7, height: self.mainView.bounds.height*0.7))
        self.watermarkImageView.image = UIImage(named: "ieeewatermark.png")
        self.watermarkImageView.contentMode = .scaleAspectFit
        self.mainView.insertSubview(self.watermarkImageView, at: 0)
        
        
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
