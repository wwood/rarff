require 'rubygems'
require 'hoe'
require './lib/rarff.rb'
 
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
    :rdoc_options => ["--exclude", "tests/*", "--main", "README.txt", "--inline-source"]
  }
 
 # task :setup_rb_package => [:clean, :package] do
 #   
 #   package_dir = "#{p.name}-#{p.version}"
 #   cp("setup.rb","pkg/#{package_dir}")
 #   #cp("manual.pdf","pkg/#{package_dir}")
 #   
 #   Dir.chdir("pkg")
 #   system("tar -czf #{p.name}-#{p.version}.tgz #{package_dir}")
 #   Dir.chdir("..")
# 
#  end
 
end
