Pod::Spec.new do |s|
  s.name             = "LeakFinder"
  s.version          = "0.2.0"
  s.summary          = "A simple tool to find memory leaks in UI code."
  s.description      = <<-DESC
A simple tool to find memory leaks in UI code. Automatically detects memory leaks in view controllers and views.
No code changes required and one-line integration.
                       DESC

  s.homepage         = "https://github.com/Lukas-Stuehrk/LeakFinder"
  s.license          = 'MIT'
  s.author           = { "Lukas Stührk" => "Lukas@Stuehrk.net" }
  s.source           = { :git => "https://github.com/Lukas-Stuehrk/LeakFinder.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'UIKit'
end
