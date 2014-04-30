# -*- encoding: utf-8 -*-
# stub: mysql_parser 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "mysql_parser"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2014-04-30"
  s.description = "A parser for MySQL DDL statements."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "lib/mysql_parser.rb", "lib/mysql_parser/value_parser.rb", "lib/mysql_parser/version.rb", "spec/mysql_parser_spec.rb", "spec/mysql_parser_spec/value_parser_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/blackwinter/mysql_parser"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\nmysql_parser-0.0.1 [2014-04-30]:\n\n* First release (extracted from ruby-nuggets).\n\n"
  s.rdoc_options = ["--title", "mysql_parser Application documentation (v0.0.1)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.2.2.x"
  s.summary = "Parse MySQL statements."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hen>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<hen>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<hen>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
