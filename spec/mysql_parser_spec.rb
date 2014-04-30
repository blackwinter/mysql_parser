describe MysqlParser do

  before :all do
    @parser = MysqlParser.new
  end

  example do
    @parser.parse([]).tables.should == {}
  end

  example do
    @parser.parse([
      'USE `foo`',
      'CREATE TABLE `bar` (',
      '  `baz` INTEGER',
      ');',
      'INSERT INTO `bar` VALUES (42);'
    ]).tables.should == { 'foo' => { 'bar' => [{ 'baz' => 42 }] } }
  end

end
