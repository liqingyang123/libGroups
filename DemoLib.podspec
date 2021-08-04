#
# Be sure to run `pod lib lint DemoLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DemoLib' # 私有库名称，pod search name 可查看是否存在
  s.version          = '0.2.3' # 私有库版本，和 git tag 保持一致
  s.summary          = '搭建私有库' # 摘要

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here. # 详细描述
                       DESC

  s.homepage         = 'https://www.baidu.com'# 可访问的地址即可
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liqingyang123' => '1402494675@qq.com' }# 作者
  s.source           = { :git => 'https://github.com/liqingyang123/DemoLib.git', :tag => s.version.to_s }# 私有库地址
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DemoLib/Classes/{const,timerCategory}/*.{h,m}' #(*.{h,m}匹配所有.h.m文件) 一般把需要使用的文件放在 "库名/Class/" 路径下
  
   s.resource_bundles = {                # 图片资源
     'DemoLib' => ['DemoLib/Assets/*.png','DemoLib/Classes/ble/*.bundle']
   }

  # s.frameworks = 'UIKit', 'MapKit'      # 依赖系统 framework
  
  # s.library = 'z' // 单个                # 依赖的系统 library，这里是指系统的类似libz.tbd、libxml2.tbd这类的系统库
  # s.libraries = 'z','xml2' // 多个
  
  s.vendored_frameworks = 'DemoLib/Classes/LQYDefine/LQYDefine.framework' #(*.{framework}) #依赖第三方 framework
  
  # s.vendored_libraries = 'libNodeMediaClient.a'                #依赖第三方 .a 文件（.a文件只是二进制文件,需配合.h文件使用）
  
  # s.public_header_files = 'Pod/Classes/**/*.h'  # 如果拖⼊的是第三⽅.a库，有.h头⽂件的，.h文件⽤ public_header_files 引入
  
  # s.dependency 'AFNetworking', '~> 2.3'  # 依赖三方库
  
  # 如果库中有很多独立的功能，只想用其中一个/几个，那么就不必 pod 整个库，可以声明 subspec“子库”
  # pod 父库，也会默认pod所有子库 (可以像 AFNetworking 那样处理，最外层用一个 .h 文件引入所有子库)
   s.subspec 'DemoLib_BLE' do |ss|
       ss.source_files = 'DemoLib/Classes/ble/*.{h,m}'
   end
  # s.subspec 'ContextModule' do |ss|
     # ss.source_files = 'PackageDemo/Classes/ContextModule/*{h,m}'
     # ss.dependency 'DemoLib/BaseModule'     # 也可以依赖 subspec 指向的⼦库
  # end
end
