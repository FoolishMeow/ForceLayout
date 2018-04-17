# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "force_layout/version"

Gem::Specification.new do |s|
  s.name             = "force_layout"
  s.version          = ForceLayout::VERSION
  s.authors          = ["ivyxuan"]
  s.email            = %q{iloveivyxuan@gmail.com}
  s.homepage         = %q{https://github.com/iloveivyxuan/ForceLayout}
  s.summary          = %q{a force directed graph layout algorithm in Ruby}
  s.description      = %q{for data visualization, compute position of nodes and edges in both 2D and 3D}
  s.extra_rdoc_files = ["README.md"]
  s.date             = Time.now
  s.licenses         = ["MIT"]

  s.required_ruby_version = '>= 2.0.0'

  s.add_development_dependency "rspec", "~> 3.4"
  s.add_development_dependency 'generator_spec'
  s.add_development_dependency 'pry'
end
