Pod::Spec.new do |s|
  s.name         = "Tambo"
  s.version      = "0.0.1"
  s.summary      = "Logging framework for linux and Apple platforms."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  "Logging framework for linux and Apple platforms."
                   DESC

  s.homepage     = "https://github.com/massdonati/tambo.git"
  s.screenshots  = ""
  s.license      = "MIT"
  s.author       = { "Massimo Donati" => "mass.donati@gmail.com" }
  s.ios.deployment_target = "11.0"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"
  s.osx.deployment_target = "10.12"
  s.source       = { :git => "https://github.com/massdonati/tambo.git", :tag => "0.0.1" }
  s.source_files  = 'Tambo/***/**/*.swift', 'Tambo/*.swift'
  s.swift_version = "4.1"
end