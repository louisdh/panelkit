Pod::Spec.new do |s|
  s.name = 'PanelKit'
  s.version = '0.8'
  s.license = 'MIT'
  s.summary = 'A UI framework that enables panels on iOS.'
  s.homepage = 'https://github.com/louisdh/panelkit'
  s.social_media_url = 'http://twitter.com/LouisDhauwe'
  s.authors = { 'Louis D\'hauwe' => 'louisdhauwe@silverfox.be' }
  s.source = { :git => 'https://github.com/louisdh/panelkit.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  
  s.source_files = 'PanelKit/*.swift'
end
