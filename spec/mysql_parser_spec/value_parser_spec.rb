describe MysqlParser::ValueParser do

  before :all do
    @value_parser = MysqlParser::ValueParser.new
  end

  example do
    @value_parser.parse('').should == []
  end

  example do
    @value_parser.parse('(42)').should == [[42]]
  end

  example do
    @value_parser.parse('(2.3)').should == [[2.3]]
  end

  example do
    @value_parser.parse("('foo')").should == [['foo']]
  end

  example do
    @value_parser.parse('(NULL)').should == [[nil]]
  end

  example do
    @value_parser.parse("('foo',NULL,42)").should == [['foo', nil, 42]]
  end

  example do
    @value_parser.parse("('foo',NULL,42), ('bar', 'baz', 2.3)").should == [['foo', nil, 42], ['bar', 'baz', 2.3]]
  end

  example do
    lambda { @value_parser.parse('("foo")') }.should raise_error(RuntimeError, /Unclosed row/)
  end

end
