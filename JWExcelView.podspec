Pod::Spec.new do |s|

  s.name         = "JWExcelView"
  s.version      = "0.0.6"
  s.summary      = "Lightweight table view"
  s.description  = <<-DESC
                    if you need show 100x100 item on iPhone, use this.
                   DESC

  s.homepage     = "https://github.com/MR-yo/JWExcelView"
  s.license      = "MIT"
  s.authors      = { "一只皮卡丘" => "syealife@gmail.com" }
  s.source       = { :git => "https://github.com/MR-yo/JWExcelView.git", :tag => "#{s.version}" }
  s.platform     = :ios, "6.0"
  s.source_files = "JWExcelView/JWExcelView/JWExcelView/*.{h,m}"

end
