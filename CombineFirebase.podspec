#
# Be sure to run `pod lib lint CombineFirebase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CombineFirebase'
  s.version          = '0.2.6'
  s.summary          = 'Combine extensions for Firebase'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Combine extensions for Firebase
  Including for now Firestore
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

  s.subspec 'Firestore' do |firestore|
    firestore.dependency 'CombineFirebaseFirestore', '~> 0.2'
    firestore.source_files = "Sources/Core/Firestore.swift"
  end

  s.subspec 'RemoteConfig' do |remote|
    remote.dependency 'CombineFirebaseRemoteConfig', '~> 0.2'
    remote.source_files = "Sources/Core/RemoteConfig.swift"
  end

  
  s.subspec 'Database' do |database|
    database.dependency 'CombineFirebaseDatabase', '~> 0.2'
    database.source_files = "Sources/Core/Database.swift"
  end
  
  
  s.subspec 'Storage' do |storage|
    storage.dependency 'CombineFirebaseStorage', '~> 0.2'
    storage.source_files = "Sources/Core/Storage.swift"
  end


  s.subspec 'Functions' do |functions|
    functions.dependency 'CombineFirebaseFunctions', '~> 0.2'
    functions.source_files = "Sources/Core/Functions.swift"
  end


  s.subspec 'Auth' do |auth|
    auth.dependency 'CombineFirebaseAuthentication', '~> 0.2'
    auth.source_files = "Sources/Core/Auth.swift"
  end

end
