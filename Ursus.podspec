Pod::Spec.new do |s|
  s.name = "Ursus"
  s.version = "1.0.1"
  s.summary = "An Urbit HTTP/`%eyre` client for iOS/macOS."
  s.homepage = "https://github.com/dclelland/Ursus"
  s.license = { type: 'MIT' }
  s.author = { "Daniel Clelland" => "daniel.clelland@gmail.com" }
  s.source = { get: "https://github.com/dclelland/Ursus.git", tag: "1.0.1" }
  s.swift_versions = ['5.1', '5.2']
  
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.13'
  
  s.source_files = 'Ursus/**/*.swift'
  
  s.dependency 'Alamofire', '~> 5.2'
  
  s.subspec 'EventSource' do |ss|
    ss.source_files = 'Ursus Event Source/**/*.swift'
  end
  
  s.subspec 'Utilities' do |ss|
    ss.source_files = 'Ursus Utilities/**/*.swift'
    ss.dependency 'UInt128', '~> 0.8'
  end
end
