# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift

use_frameworks!

target 'Scenari' do
    
pod 'Parse'
pod 'ParseUI'
pod 'ParseFacebookUtils'
pod 'Fabric'
pod 'Crashlytics'
pod 'ChameleonFramework/Swift'
pod 'MBProgressHUD'
#pod 'PopupController'
pod 'DZNEmptyDataSet'
pod 'Fusuma', '~>0.5'
#pod 'Fusuma', :git => 'https://github.com/pruthvikar/Fusuma.git', :commit => '503865a' # Swift 3.0 Version
pod 'SDCSegmentedViewController'
#pod 'SwiftDateTools'
pod 'LaunchKit'


end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

target 'ScenariTests' do

end

target 'ScenariUITests' do

end

