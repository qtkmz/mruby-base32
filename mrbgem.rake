MRuby::Gem::Specification.new('mruby-base32') do |spec|
  spec.license = 'MIT'
  spec.author  = 'qtakamitsu'
  spec.summary = 'Base32 class'
  spec.add_dependency 'mruby-string-ext'
  spec.add_dependency 'mruby-pack'
end
