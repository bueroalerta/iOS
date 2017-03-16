source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

def pods
  pod 'DateToolsSwift'
  pod 'Charts', '~> 3.0.1'
  pod 'SnapKit', '~> 3.0.2'
  pod 'Alamofire', '~> 4.3.0'
  pod 'Moya', '~> 8.0.2'
  pod 'Kingfisher', '~> 3.1.0'
  
  pod 'Pingpp/Alipay', '~> 2.2.10'
  pod 'Pingpp/Wx', '~> 2.2.10'
  
  pod 'ShareSDK3'
  pod 'MOBFoundation'
  pod 'ShareSDK3/ShareSDKUI'
  pod 'ShareSDK3/ShareSDKExtension'
  pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
  
  pod 'Google/Analytics'
  pod 'KSCrash', '~> 1.8.13'
  
  pod 'QRCode', '~> 2.0'
  pod 'Proposer', '~> 1.1.0'
  pod 'WZLBadge', '~> 1.2.5'
  pod 'Toast-Swift', '~> 2.0.0'
  pod 'KYCircularProgress', '~> 1.0.0'
  pod 'IQKeyboardManagerSwift', '~> 4.0.8'
  pod 'KMNavigationBarTransition', '~> 1.0.0'
  pod 'AnimatedGIFImageSerialization', '~> 0.2.0'
  pod 'SKPhotoBrowser', :git => 'https://github.com/suzuki-0000/SKPhotoBrowser.git', :branch => 'swift3'
  pod 'PagingMenuController', :git => 'https://github.com/kitasuke/PagingMenuController.git', :commit => '3d4e5cc2096bc7ebbf9ff9e3b31c8d5e168062d5'
  # pod 'YLProgressBar', '~> 3.10.1'
end

target 'parent-dev' do
  pods

  target 'parentTests' do
    inherit! :search_paths
  end
end

target 'parent-stage' do
  pods
end

target 'parent-prd' do
  pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    case target.name
      when 'Alamofire', 'Charts', 'IQKeyboardManager', 'Kingfisher', 'SnapKit','PagingMenuController'
        target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
