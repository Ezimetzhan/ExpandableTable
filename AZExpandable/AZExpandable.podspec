
Pod::Spec.new do |s|
  s.name             = 'AZExpandable'
  s.version          = '0.0.1'
  s.summary          = 'AZExpandable is a lightweight ability to expand cell of UITableView with issues with layout or index calculations.'

  s.platform = :ios
  s.ios.deployment_target = '7.0'

  s.homepage         = 'https://github.com/azonov/expandableTable.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andrey Zonov' => 'andryzonov@gmail.com' }
  s.source           = { :git => 'https://github.com/azonov/expandableTable.git', :tag => s.version.to_s }

  s.source_files = 'AZExpandable/Classes/**/*'

end
