//
//  ViewController.swift
//  GoogleAnalyticsInjectorDemo
//
//  Created by HiromiMotodera on 2015/04/19.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

import UIKit

class AppleViewController: UIViewController {
    
    var appleImage = UIImage(named:"Apple.jpg")!
    var appleButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Apple"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.appleButton.setBackgroundImage(self.appleImage, forState:.Normal)
        self.appleButton.addTarget(self, action:"didTapAppleButton", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.appleButton)
        
        var nextBarButton = UIBarButtonItem(title:"Next", style:.Plain, target:self, action:"didTapNextBarButton")
        self.navigationItem.rightBarButtonItem = nextBarButton
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
    }
    
    // MARK: Button action
    
    dynamic func didTapAppleButton() {
        println("Apple!")
    }
    
    dynamic func didTapNextBarButton() {
        var viewController = BananaViewController()
        self.navigationController?.pushViewController(viewController, animated:true)
    }
    
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.appleButton.frame = CGRectMake(
            (self.view.bounds.size.width - self.appleImage.size.width) * 0.5,
            (self.view.bounds.size.height - self.appleImage.size.height) * 0.5,
            self.appleImage.size.width,
            self.appleImage.size.height)
    }
    
    // MARK: Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

