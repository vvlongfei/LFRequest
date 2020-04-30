#
# Be sure to run `pod lib lint LFRequest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LFRequest'
  s.version          = '0.1.0'
  s.summary          = 'AFNetworking的再次封装，方便使用.'

  s.description      = <<-DESC
对AFNetworking的封装，使用方便，可配置性强。可以单独配置单个接口的解析、数据返回线程等。
                       DESC

  s.homepage         = 'https://github.com/vvlongfei/LFRequest'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'feiyu' => 'vvlongfei@163.com' }
  s.source           = { :git => 'https://github.com/vvlongfei/LFRequest.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.requires_arc = true
  
  s.ios.deployment_target = '9.0'

  s.source_files = 'LFRequest/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LFRequest' => ['LFRequest/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'AFNetworking'
   s.dependency 'YYModel'
   s.dependency 'YYCache'
end
