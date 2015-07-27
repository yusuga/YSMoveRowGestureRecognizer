Pod::Spec.new do |s|
  s.name = 'YSMoveRowGestureRecognizer'
  s.version = '0.0.3'
  s.summary = 'YSMoveRowGestureRecognizer'
  s.homepage = 'https://github.com/yusuga/YSMoveRowGestureRecognizer'
  s.license = 'MIT'
  s.author = 'Yu Sugawara'
  s.source = { :git => 'https://github.com/yusuga/YSMoveRowGestureRecognizer.git', :tag => s.version.to_s }
  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/YSMoveRowGestureRecognizer/*.{h,m}'
  s.requires_arc = true
  s.compiler_flags = '-fmodules'
end