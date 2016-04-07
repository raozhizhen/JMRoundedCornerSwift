//
//  ViewController.swift
//  JMRoundedCornerSwift
//
//  Created by jm on 16/4/5.
//  Copyright © 2016年 JM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource{
    
    override func loadView() {
        super.loadView()
        self.title = "使用JMRoundedCorner绘制圆角"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "切换", style: .Plain, target: self, action:#selector(action))
        let tableView = UITableView.init(frame: self.view.frame, style: .Plain)
        tableView.registerClass(TableViewCell.classForCoder(), forCellReuseIdentifier: TableViewCell.cellResuseIdentifier())
        tableView.rowHeight = 54;
        tableView.dataSource = self;
        self.view.addSubview(tableView);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello World")
        // Do any   additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell .cellResuseIdentifier(), forIndexPath: indexPath)
        return cell
    }
    
    func action() {
        NSLog("hahah")
    }

}

class TableViewCell: UITableViewCell {
    static func cellResuseIdentifier() -> String {
        return NSStringFromClass(TableViewCell.classForCoder())
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.backgroundColor = UIColor.lightGrayColor()
        let avatarView = UIImageView.init(frame: CGRectMake(10, 7, 40, 40))
        avatarView.jm_setRadiusWith(JMRadiusMake(20, 20, 20, 20), borderColor: nil, borderWidth: 0.0, backgroundColor: nil, backgroundImage: UIImage.init(named: "avatar.jpg"), contentMode: .ScaleAspectFill)
        self.contentView.addSubview(avatarView)
    }
}


