# Uncomment the next line to define a global platform for your project
  platform :ios, '10.0'

target 'smios' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for smios
      pod 'Alamofire', '~> 4.0'
      pod 'SwiftyJSON'
      pod 'FacebookLogin'
      pod 'React', :path => '../node_modules/react-native', :subspecs => [
        'Core',
        'RCTText',
        'RCTNetwork',
        'RCTImage',
        'RCTSettings',
        'RCTVibration',
        'RCTCameraRoll',
        'RCTWebSocket', # needed for debugging
        # Add any other subspecs you want to use in your project
      ]

  target 'smiosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'smiosUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
