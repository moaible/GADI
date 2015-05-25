//
//  BananaViewController.swift
//  GoogleAnalyticsInjectorDemo
//
//  Created by HiromiMotodera on 2015/04/19.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

import UIKit

class BananaViewController: UIViewController {
    
    var bananaImage = UIImage(named:"Banana.jpg")!
    var bananaButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Banana"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.bananaButton.setBackgroundImage(self.bananaImage, forState:.Normal)
        self.bananaButton.addTarget(self, action:"didTapBananaButton", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.bananaButton)
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        var nextBarButton = UIBarButtonItem(title:"Next", style:.Plain, target:self, action:"didTapNextBarButton")
        self.navigationItem.rightBarButtonItem = nextBarButton
        self.navigationController?.navigationBar.barTintColor = UIColor.yellowColor()
    }
    
    // MARK: Button action
    
    dynamic func didTapBananaButton() {
        println("Banana!")
    }
    
    dynamic func didTapNextBarButton() {
        var viewController = OrangeViewController()
        self.navigationController?.pushViewController(viewController, animated:true)
    }
    
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.bananaButton.frame = CGRectMake(
            (self.view.bounds.size.width - self.bananaImage.size.width) * 0.5,
            (self.view.bounds.size.height - self.bananaImage.size.height) * 0.5,
            self.bananaImage.size.width,
            self.bananaImage.size.height)
    }
    
    // MARK: Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
