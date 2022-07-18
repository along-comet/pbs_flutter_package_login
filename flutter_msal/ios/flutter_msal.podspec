#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_msal.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_msal'
  s.version          = '0.0.3'
  s.summary          = 'A Flutter plugin that provides an interface for Microsoft Authentication Library (MSAL).'
  s.description      = <<-DESC
A Flutter plugin that provides an interface for Microsoft Authentication Library (MSAL).

The aim of the library is the token acquisition from the Microsoft Identity platform,
it does not implement various supported features of the native libraries for now.
                       DESC
  s.homepage         = 'https://www.shareitsolutions.com'
  s.license          = { :file => '../LICENSE', :type => 'MIT' }
  s.author           = { 'Share IT Ltd' => 'contact@shareit.rs' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'MSAL'
  s.platform = :ios, '11.0'
  s.ios.deployment_target = '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
