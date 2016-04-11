Pod::Spec.new do |s|
  s.name             = "BFTaskCenter"
  s.version          = "0.1.0"
  s.summary          = "BFTaskCenter is an center to send task to register."
  s.description      = <<-DESC
                       BFTaskCenter work like NSNotificationCenter, is can send result and error to register.
                       DESC

  s.homepage         = "https://github.com/Superbil/BFTaskCenter"

  s.license          = 'MIT'
  s.author           = { "Superbil" => "superbil@gmail.com" }
  s.source           = { :git => "https://github.com/Superbil/BFTaskCenter.git", :tag => "v#{s.version.to_s}" }
  s.social_media_url = 'https://twitter.com/Superbil'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'Bolts', '~> 1.5'
end
