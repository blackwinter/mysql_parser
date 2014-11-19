require_relative 'lib/mysql_parser/version'

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{mysql_parser},
      version:      MysqlParser::VERSION,
      summary:      %q{Parse MySQL statements.},
      description:  %q{A parser for MySQL DDL statements.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      dependencies: %w[],

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
