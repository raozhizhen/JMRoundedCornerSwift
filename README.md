## 此库太久没更新了，请勿使用

# JMRoundedCornerSwift

UIView settings without triggering off-screen rendering fillet /UIView设置不触发离屏渲染的圆角 


```ruby
# platform :ios, ‘8.0’
use_frameworks!
pod ‘JMRoundedCornerSwift’
```

```swift
import JMRoundedCornerSwift

class ViewController: UIViewController {

    override func loadView() {
        super.loadView()

        let avatarView = UIView.init(frame: CGRectMake(10, 7, 40, 40))
        avatarView.radiusWith(20, backgroundImage: UIImage.init(named: "avatar.jpg"))
        contentView.addSubview(avatarView)
        
    }

}
```
