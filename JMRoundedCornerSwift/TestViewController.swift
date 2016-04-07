//
//  TestViewController.swift
//  JMRoundedCornerSwift
//
//  Created by jm on 16/4/7.
//  Copyright © 2016年 JM. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    var imageView = UIImageView()
    var slider0 = UISlider()
    var slider1 = UISlider()
    var slider2 = UISlider()
    var slider3 = UISlider()
    var slider4 = UISlider()

    override func loadView() {
        
        super.loadView()
        title = "测试页面"
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        imageView = UIImageView.init(frame: CGRectMake(20, 100, 300, 200))
        imageView.JMRadiusWith(JMRadiusMake(20, 20, 20, 20), borderColor: UIColor.redColor(), borderWidth: 10, backgroundColor: UIColor.blueColor(), backgroundImage: UIImage.init(named: "avatar.jpg"), contentMode: .ScaleAspectFill)
        view.addSubview(imageView)
        
        slider0 = UISlider.init(frame: CGRectMake(20, 400, 300, 20))
        slider0.minimumValue = 0;
        slider0.maximumValue = 300;
        slider0.value = 20;
        view.addSubview(slider0)

        slider1 = UISlider.init(frame: CGRectMake(20, 440, 300, 20))
        slider1.minimumValue = 0;
        slider1.maximumValue = 300;
        slider1.value = 20;
        view.addSubview(slider1)
        
        slider2 = UISlider.init(frame: CGRectMake(20, 480, 300, 20))
        slider2.minimumValue = 0;
        slider2.maximumValue = 300;
        slider2.value = 20;
        view.addSubview(slider2)
        
        slider3 = UISlider.init(frame: CGRectMake(20, 520, 300, 20))
        slider3.minimumValue = 0;
        slider3.maximumValue = 300;
        slider3.value = 20;
        view.addSubview(slider3)
        
        slider4 = UISlider.init(frame: CGRectMake(20, 560, 300, 20))
        slider4.minimumValue = 0;
        slider4.maximumValue = 100;
        slider4.value = 10;
        view.addSubview(slider4)
        
        slider0.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.change()
        }
        
        slider1.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.change()
        }
        
        slider2.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.change()
        }
        
        slider3.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.change()
        }
        
        slider4.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.change()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any   additional setup after loading the view, typically from a nib.
    }
    
    func change() {
        imageView.JMRadiusWith(JMRadiusMake(CGFloat(slider0.value), CGFloat(slider1.value), CGFloat(slider2.value), CGFloat(slider3.value)), borderColor:UIColor.redColor(), borderWidth: CGFloat(slider4.value), backgroundColor: nil, backgroundImage: UIImage.init(named: "avatar.jpg"), contentMode: .ScaleAspectFill)
    }
}