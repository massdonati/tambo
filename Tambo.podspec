Pod::Spec.new do |s|
  s.name         = "Tambo"
  s.version      = "1.1.7"
  s.summary      = "Logging framework for linux and Apple platforms."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  "Logging framework for linux and Apple platforms."
                   DESC

  s.homepage     = "https://github.com/massdonati/tambo"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Massimo Donati" => "mass.donati@gmail.com" }
  s.ios.deployment_target = "13.0"
  s.watchos.deployment_target = "6.2"
  s.tvos.deployment_target = "13.3"
  s.osx.deployment_target = "10.15"
  s.source       = { :git => "https://github.com/massdonati/tambo.git", :tag => s.version.to_s }
  s.source_files  = 'Tambo/***/**/*.swift', 'Tambo/*.swift'
  s.swift_version = "5"
end
