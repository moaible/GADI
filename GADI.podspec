d::Spec.new do |s|
  s.name         	= "GADI"
  s.version      	= "0.0.1"
  s.summary      	= "Google Analytics Dependency Injection"
  s.homepage     	= "https://github.com/MO-AI/GADI"
  s.license      	= 'MIT'
  s.author       	= { "Hiromi Motodera" => "moai.motodera@gmail.com" }
  s.source       	= { :git => "https://github.com/MO-AI/GADI.git", :tag => "#{s.version}", :submodules => true }
  s.source_files = 'GADI/*.{swift}'
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.8"
  s.requires_arc 	= true
  s.subspec 'MOAspects' do |ss|
    ss.source_files = 'MOAspects/*.{h,m}'
  end
  s.subspec 'GoogleAnalytics-iOS-SDK' do |ss|
    ss.source_files = 'GoogleAnalytics-iOS-SDK/*.{h}'
  end
end
