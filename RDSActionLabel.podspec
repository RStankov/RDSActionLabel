#
#  Be sure to run `pod spec lint RDSActionLabel.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name          = "RDSActionLabel"
  s.version       = "1.0.0"
  s.summary       = "Custom text highlighting in UILabel."
  s.description   = "A UILabel subclass, that adds highlighting support to labels. Supporting hashtags, mentions, urls and having the ability to recognize custom texts. Written in Swift."
  s.homepage      = "https://github.com/RStankov/RDSActionLabel"
  s.license       = { type: 'MIT', file: 'LICENSE.txt' }
  s.author        = { "Radoslav Stankov" => "rstankov@gmail.com" }
  s.platform      = :ios, '8.0'
  s.source        = { git: "https://github.com/RStankov/RDSActionLabel.git", tag: s.version }
  s.source_files  = "RDSActionLabel/*.{swift}"
end
