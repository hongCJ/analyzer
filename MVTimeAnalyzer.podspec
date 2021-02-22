#
# Be sure to run `pod lib lint MVTimeAnalyzer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MVTimeAnalyzer'
  s.version          = '1.2.0'
  s.summary          = '用于统计素材是否处于可见状态，且达到一秒'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
此库的目的是用来统计素材的可见时间，即处于可见的范围内的状态，时间则是一秒钟。基于性能的考虑，统计的时间不会很精准，只是作为一个大概的分析参考
                       DESC

  s.homepage         = 'https://bitbucket.org/sealcn/mvtimeanalyzer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhenghong' => 'zhenghong@daily.com' }
  s.source           = { :git => 'git@bitbucket.org:sealcn/mvtimeanalyzer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'MVTimeAnalyzer/Classes/**/*'
  s.swift_version = '5.0'
  # s.resource_bundles = {
  #   'MVTimeAnalyzer' => ['MVTimeAnalyzer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
