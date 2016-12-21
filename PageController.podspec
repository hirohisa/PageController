Pod::Spec.new do |s|

  s.name         = "PageController"
  s.version      = "0.5.0"
  s.summary      = "Infinite paging controller, scrolling through contents and title bar scrolls with a delay for iOS written in Swift."
  s.description  = <<-DESC
PageController is infinite paging controller, scrolling through contents and title bar scrolls with a delay. Then it provide user interaction to smoothly and effortlessly moving. It is for iOS written in Swift.
                   DESC

  s.homepage     = "https://github.com/hirohisa/PageController"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Hirohisa Kawasaki" => "hirohisa.kawasaki@gmail.com" }

  s.source       = { :git => "https://github.com/hirohisa/PageController.git", :tag => s.version }

  s.source_files = "PageController/*.swift"
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
end
