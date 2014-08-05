describe MysqlParser::ValueParser do

  def parsing(input)
    @value_parser.parse(input)
  end

  before :all do
    @value_parser = MysqlParser::ValueParser.new
  end

  example do
    parsing('').should == []
  end

  example do
    parsing('(42)').should == [[42]]
  end

  example do
    parsing('(2.3)').should == [[2.3]]
  end

  example do
    parsing("('foo')").should == [['foo']]
  end

  example do
    parsing('(NULL)').should == [[nil]]
  end

  example do
    parsing("('foo',NULL,42)").should == [['foo', nil, 42]]
  end

  example do
    parsing("('foo',NULL,42), ('bar', 'baz', 2.3)").should == [['foo', nil, 42], ['bar', 'baz', 2.3]]
  end

  example do
    lambda { parsing('("foo")') }.should raise_error(RuntimeError, /Unclosed row/)
  end

end
