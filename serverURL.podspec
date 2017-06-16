Pod::Spec.new do |s|

  s.name         = "serverURL"
  s.version      = "0.0.1"
  s.summary      = "ifLab在BISTU校内应用为了配合App Store审核所做的妥协."
  s.homepage     = "https://github.com/billhu1996/serverURL"
  s.license      = "MIT"
  s.author             = { "billhu1996" => "billhu1996@gmail.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/billhu1996/serverURL.git", :tag => "#{s.version}" }
  s.source_files  = "serverURL/*.{h,m}"
  s.framework    = "UIKit"
  s.requires_arc = true

end
