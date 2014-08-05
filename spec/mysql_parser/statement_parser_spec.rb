describe MysqlParser::StatementParser do

  def parsing(input)
    lambda { |b| @statement_parser.parse(input, &b) }
  end

  before :all do
    @statement_parser = MysqlParser::StatementParser.new
  end

  example do
    parsing('').should_not yield_control
  end

  example do
    parsing('USE `foo`').should yield_with_args(:use, 'foo')
  end

  example do
    parsing('CREATE TABLE `bar` (').should yield_with_args(:create, 'bar')
  end

  example do
    parsing('  `baz` INTEGER').should yield_with_args(:column, 'baz')
  end

  example do
    parsing(');').should yield_with_args(:table)
  end

  example do
    parsing('INSERT INTO `bar` VALUES (42);').should yield_with_args(:insert, 'bar', nil, '(42)')
  end

end
