//
//  ViewController2.swift
//  JMRoundedCornerSwift
//
//  Created by jm on 16/4/7.
//  Copyright © 2016年 JM. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, UITableViewDataSource {
    
    override func loadView() {
        
        super.loadView()
        title = "使用layer.cornerRadius"
        let tableView = UITableView.init(frame: view.frame, style: .Plain)
        tableView.registerClass(TableViewCell2.classForCoder(), forCellReuseIdentifier: TableViewCell.cellResuseIdentifier())
        tableView.rowHeight = 54
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any   additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1000
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell2.cellResuseIdentifier(), forIndexPath: indexPath)
        return cell
    }
}

class TableViewCell2: UITableViewCell {

    var didSetupConstraints = false
    
    static func cellResuseIdentifier() -> String {
        
        return NSStringFromClass(TableViewCell.classForCoder())
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.backgroundColor = UIColor.lightGrayColor()
        
        let avatarView = UIImageView.init(frame: CGRectMake(10, 7, 40, 40))
        avatarView.contentMode = .ScaleAspectFill;
        avatarView.image = UIImage.init(named: "avatar.jpg");
        avatarView.layer.borderWidth = 0.5;
        avatarView.layer.borderColor = UIColor.redColor().CGColor;
        avatarView.layer.cornerRadius = 20;
        avatarView.layer.masksToBounds = true;
        avatarView.layer.shouldRasterize = true;
        avatarView.layer.rasterizationScale = UIScreen.mainScreen().scale;
        contentView.addSubview(avatarView)
        
        let viewWidth = (UIScreen.mainScreen().bounds.size.width - 80) / 2;
        let button = UIButton.init(frame: CGRectMake(60, 7, viewWidth, 40))//测试坐标不落在像素点上虚化问题
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = true;
        button.layer.shouldRasterize = true;
        button.layer.contents = UIImage.init(named: "avatar.jpg")?.CGImage
        button.contentMode = .ScaleAspectFill;
        button.layer.rasterizationScale = UIScreen.mainScreen().scale;
        button.titleLabel?.font = UIFont.systemFontOfSize(12)
        button.setTitle("button", forState: .Normal)
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        contentView.addSubview(button)
        
        let label = UILabel.init(frame: CGRectMake(70 + viewWidth, 7, viewWidth, 40))
        label.text = "label"
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = UIColor.redColor().CGColor;
        label.layer.cornerRadius = 10;
        label.layer.backgroundColor = UIColor.whiteColor().CGColor
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        contentView.addSubview(label)
        
        contentView.setNeedsUpdateConstraints()
    }
}