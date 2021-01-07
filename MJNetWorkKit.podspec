#
# Be sure to run `pod lib lint MJNetWorkKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MJNetWorkKit'
  s.version          = '1.1.9'
  s.summary          = '在CTNetworking基础上封装的一套网络请求框架'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
依赖于AFNetworking、CTMediator、CTNetworking的网络请求框架，在CTNetworking基础上做了更具体更贴近业务的改动。
                       DESC

  s.homepage         = 'https://github.com/jgyhc/MJNetWorkKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '刘聪' => 'jgyhc@foxmail.com' }
  s.source           = { :git => 'https://github.com/jgyhc/MJNetWorkKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MJNetWorkKit/Classes/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'MJNetWorkKit' => ['MJNetWorkKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'AFNetworking', 'CTMediator', 'CTNetworking'
  s.dependency 'AFNetworking'
  s.dependency 'CTMediator'
  s.dependency 'CTNetworking'
  # s.dependency 'MJOauthTokenTool'

end
