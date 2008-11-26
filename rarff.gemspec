Gem::Specification.new do |s|

  s.name = %q{rarff}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andy Payne, Ben J Woodcroft"]
  s.date = %q{2008-11-25}
  s.description = %q{Rarff is a Ruby library for dealing with Attribute-Relation File Format (ARFF) files. ARFF files are used to specify  data sets for data mining and machine learning.}
  s.email = %q{apayne .at. gmail.com, b.woodcroft@pgrad.unimelb.edu.au}
  s.extra_rdoc_files = ["README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/rarff.rb", "test/test_arff.arff", "test/test_sparse_arff.arff", "test/test_rarff.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://adenserparlance.blogspot.com/2007/01/rarff-simple-arff-library-in-ruby.html}
  s.rdoc_options = ["--exclude", "test/*", "--main", "README.txt", "--inline-source"]
  s.require_paths = ["lib", "test"]
  s.rubyforge_project = %q{rarff}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Rarff is a Ruby library for dealing with Attribute-Relation File Format (ARFF) files}
  s.test_files = ["test/test_rarff.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<hoe>, [">= 1.8.2"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.2"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.2"])
  end
end
