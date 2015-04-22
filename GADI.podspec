Pod::Spec.new do |s|
  s.name         	= "GADI"
  s.version      	= "0.0.1"
  s.platfrom      = :ios, "5.0"
  s.summary      	= "Google Analytics Dependency Injection for iOS"
  s.homepage     	= "https://github.com/MO-AI/GADI"
  s.license      	= 'MIT'
  s.author       	= { "Hiromi Motodera" => "moai.motodera@gmail.com" }
  s.source       	= { :git => "https://github.com/MO-AI/GADI.git", :tag => "#{s.version}", :submodules => true }
  s.source_files = 'GADI/*.{h,m}'
  s.ios.deployment_target = "5.0"
  s.requires_arc 	= true
  s.subspec "GADI" do |ss|
    ss.dependency "MOAspects", '> 2.0.3'
  end
end
