require 'rubygems'
require 'hoe'
#require './lib/rarff.rb'
 
gem_name = 'rarff'
hoe = Hoe.new(gem_name,'0.2.1') do |p|
  
  p.author = "Andy Payne, Ben J Woodcroft"
  p.email = "apayne .at. gmail.com, b.woodcroft@pgrad.unimelb.edu.au"
  p.url = "http://adenserparlance.blogspot.com/2007/01/rarff-simple-arff-library-in-ruby.html"
  
  p.description = 'Rarff is a Ruby library for dealing with Attribute-Relation File Format (ARFF) files. ARFF files are used to specify 
data sets for data mining and machine learning.'
  p.summary = 'Rarff is a Ruby library for dealing with Attribute-Relation File Format (ARFF) files'
  
  p.rdoc_pattern = /(^lib\/.*\.rb$|^examples\/.*\.rb$|^README|^History|^License)/
  
  p.spec_extras = {
    :require_paths => ['lib','test'],
    :has_rdoc => true,
    :extra_rdoc_files => ["README.txt"],
    :rdoc_options => ["--exclude", "test/*", "--main", "README.txt", "--inline-source"]
  }
end
