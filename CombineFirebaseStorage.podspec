#
# Be sure to run `pod lib lint CombineFirebaseStorage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'CombineFirebaseStorage'
    s.version          = '0.2.4'
    s.summary          = 'Combine extensions for Firebase Storage.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    Combine extensions for Firebase/Storage.
    DESC
    
    s.homepage         = 'https://github.com/rever-ai/CombineFirebase'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'kshivang' => 'shivang.iitk@gmail.com' }
    s.source           = { :git => 'https://github.com/rever-ai/CombineFirebase.git', :tag => s.version.to_s }
    

    s.ios.deployment_target = '13.0'
    s.osx.deployment_target = '10.15'
    #s.watchos.deployment_target = '6.0'
    s.tvos.deployment_target = '13.0'

    s.static_framework = true

    s.swift_version = '5.1'

    s.dependency 'Firebase/Storage'

    s.source_files = 'Sources/Storage/**/*'
end

