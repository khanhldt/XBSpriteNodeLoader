
Pod::Spec.new do |s|

  s.name         = "XBSpriteNodeLoader"
  s.version      = "1.0.0"
  s.summary      = "iOS sprite node loader helper to make build things faster and more efficient with iOS new tool SpriteKit."
  s.homepage     = "https://github.com/ldtkhanh2306/XBSpriteNodeLoader"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "ldtkhanh2306" => "ldtkhanh2306@gmail.com" }
  s.source       = { :git => "https://github.com/ldtkhanh2306/XBSpriteNodeLoader.git", :tag => s.version }
  s.platform     = :ios, "7.0"

  s.source_files  = "XBSpriteNodeLoader/**/*.{h,m}"
  s.requires_arc = true

  s.framework  = 'SpriteKit'
  s.dependency 'XBLog', '~> 1.0.0'

  s.xcconfig = { "OTHER_LDFLAGS" => "-dynamic -ObjC -all_load" }
  
  s.prefix_header_file = 'XBSpriteNodeLoader/XBSpriteNodeLoader-Prefix.pch'

end
