Pod::Spec.new do |s|

  s.name         = "CPAnimatedPlayingIndicatorView"
  s.version      = "1.0.3"
  s.summary      = "A customizable playing indicator with animating bars."
  s.description  = "A customizable playing indicator with animating bars. Supports setting bar count, color, spacing, corner radius, animation speed and delay between animation each bar."
  s.homepage     = "https://github.com/canpoyrazoglu/CPAnimatedPlayingIndicatorView"

  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "Can Poyrazoğlu" => "can@canpoyrazoglu.com" }
  s.social_media_url   = "http://twitter.com/canpoyrazoglu"



  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/canpoyrazoglu/CPAnimatedPlayingIndicatorView.git", :tag => s.version.to_s }


  s.source_files = "Classes/**/*.{h,m}"
  s.framework    = "QuartzCore"

end
