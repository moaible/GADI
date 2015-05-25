//
//  OrangeViewController.swift
//  GoogleAnalyticsInjectorDemo
//
//  Created by HiromiMotodera on 2015/04/19.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

import UIKit

class OrangeViewController: UIViewController {
    
    var orangeImage = UIImage(named:"Orange.jpg")!
    var orangeButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Orange"
        self.navigationController?.navigationBar.barTintColor = UIColor.yellowColor()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.orangeButton.setBackgroundImage(self.orangeImage, forState:.Normal)
        self.orangeButton.addTarget(self, action:"didTapOrangeButton", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.orangeButton)
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.rightBarButtonItem = nil
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
    }
    
    // MARK: Button action
    
    dynamic func didTapOrangeButton() {
        println("Orange!")
    }
    
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.orangeButton.frame = CGRectMake(
            (self.view.bounds.size.width - self.orangeImage.size.width) * 0.5,
            (self.view.bounds.size.height - self.orangeImage.size.height) * 0.5,
            self.orangeImage.size.width,
            self.orangeImage.size.height)
    }
    
    // MARK: Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}