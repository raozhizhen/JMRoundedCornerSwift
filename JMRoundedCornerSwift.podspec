
Pod::Spec.new do |s|

  s.name         = "JMRoundedCornerSwift"
  s.version      = "0.0.1"
  s.license = 'MIT'
  s.summary      = "UIView set Corner Radius"
  s.homepage     = "https://github.com/raozhizhen/JMRoundedCornerSwift.git"
  s.license             = { :type => "MIT", :file => "LICENSE" } 
  s.author       = { "raozhizhen" => "raozhizhen@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/raozhizhen/JMRoundedCornerSwift.git", :tag => s.version }
  s.source_files = 'JMRoundedCorner/*.swift'
  s.requires_arc = true

end
