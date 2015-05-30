Pod::Spec.new do |s|
  s.name     = 'SSObject'
  s.version  = '1.2.1'
  s.license  = { :type => 'MIT' }
  s.summary  = '对象序列化反序列化 framework.'
  s.homepage = 'http://blog.isteven.cn'
  s.authors  = { 'Steven' => 'qzs21@qq.com' }
  s.source   = {
    :git => 'https://github.com/qzs21/SSObject.git',
    :tag => s.version
  }
  s.source_files = 'SSObject/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '6.0'
end
