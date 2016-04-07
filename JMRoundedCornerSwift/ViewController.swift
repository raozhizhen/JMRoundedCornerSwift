//
//  ViewController.swift
//  JMRoundedCornerSwift
//
//  Created by jm on 16/4/5.
//  Copyright © 2016年 JM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    override func loadView() {
        
        super.loadView()
        title = "使用JMRoundedCorner绘制圆角"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "切换", style: .Plain, target: self, action:#selector(action))
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "测试", style: .Plain, target: self, action:#selector(action2))
        let tableView = UITableView.init(frame: view.frame, style: .Plain)
        tableView.registerClass(TableViewCell.classForCoder(), forCellReuseIdentifier: TableViewCell.cellResuseIdentifier())
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.cellResuseIdentifier(), forIndexPath: indexPath)
        return cell
    }
    
    func action() {
        navigationController!.pushViewController(ViewController2(), animated: true)
    }
    
    func action2() {
        navigationController!.pushViewController(TestViewController(), animated: true)
    }
}

class TableViewCell: UITableViewCell {
    
    var label = UILabel()
    var textField = UITextField()
    var button = UIButton()
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
        avatarView.jm_setRadiusWith(JMRadiusMake(20, 20, 20, 20), borderColor: nil, borderWidth: 0.0, backgroundColor: nil, backgroundImage: UIImage.init(named: "avatar.jpg"), contentMode: .ScaleAspectFill)
        contentView.addSubview(avatarView)
        
        let viewWidth = (UIScreen.mainScreen().bounds.size.width - 78) / 3
        button = UIButton.init(frame: CGRectMake(60 + 0.22, 7, viewWidth + 0.34, 40))//测试坐标不落在像素点上虚化问题
        button.setTitle("button", forState: .Normal)
        button.JMRadiusWith(JMRadiusMake(10, 0, 10, 0), backgroundImage: UIImage.init(named: "avatar.jpg"))
        button.titleLabel?.font = UIFont.systemFontOfSize(12)
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        contentView.addSubview(button)
        
        label = UILabel.init()
        label.text = "label"
        label.JMRadiusWith(JMRadiusMake(0, 10, 0, 10), borderColor: UIColor.redColor(), borderWidth: 0.5, backgroundColor: nil, backgroundImage: nil, contentMode: .ScaleToFill)
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        contentView.addSubview(label)
        
        textField = UITextField.init()
        textField.text = "textField"
        textField.JMRadiusWith(JMRadiusMake(10, 20, 10, 20), borderColor: UIColor.redColor(), borderWidth: 0.5, backgroundColor: nil, backgroundImage: nil, contentMode: .ScaleToFill)
        textField.font = UIFont.systemFontOfSize(12)
        textField.textAlignment = .Center
        contentView.addSubview(textField)
        
        contentView.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        
        if (!didSetupConstraints) {
            
            label.snp_makeConstraints(closure: { (make) -> Void in
                make.left.equalTo(button.snp_right).offset(2)
                make.top.equalTo(contentView).offset(7)
                make.size.equalTo(CGSizeMake(100, 40))
            })
            
            textField.snp_makeConstraints(closure: { (make) -> Void in
                make.left.equalTo(label.snp_right).offset(2)
                make.right.equalTo(contentView).offset(-10)
                make.top.equalTo(contentView).offset(7)
                make.height.equalTo(40)
            })
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}