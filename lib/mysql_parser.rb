#--
###############################################################################
#                                                                             #
# mysql_parser -- Parse MySQL statements                                      #
#                                                                             #
# Copyright (C) 2014 Jens Wille                                               #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# mysql_parser is free software; you can redistribute it and/or modify it     #
# under the terms of the GNU Affero General Public License as published by    #
# the Free Software Foundation; either version 3 of the License, or (at your  #
# option) any later version.                                                  #
#                                                                             #
# mysql_parser is distributed in the hope that it will be useful, but WITHOUT #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License #
# for more details.                                                           #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with mysql_parser. If not, see <http://www.gnu.org/licenses/>.        #
#                                                                             #
###############################################################################
#++

class MysqlParser

  DEFAULT_NAME  = '__DEFAULT__'.freeze
  DEFAULT_TABLE = '__DEFAULT__'.freeze

  CLEAN_COLUMNS_RE = /[\s`]+/

  def self.parse(input, &block)
    parser = new.parse(input, &block)
    block ? parser : parser.tables
  end

  def initialize
    reset
  end

  def reset
    @name             = DEFAULT_NAME
    @table            = DEFAULT_TABLE

    @tables           = {}
    @columns          = Hash.new { |h, k| h[k] = [] }

    @value_parser     = ValueParser.new
    @statement_parser = StatementParser.new
  end

  attr_reader :tables

  def parse(input, &block)
    unless block
      tables, block = @tables, lambda { |_, name, table, columns, values|
        ((tables[name] ||= {})[table] ||= []) << fields = {}

        values.each_with_index { |value, index|
          if column = columns[index]
            fields[column] = value
          end
        }
      }
    end

    name, table, columns, statement_parser, value_parser, block_given =
      @name, @table, @columns, @statement_parser, @value_parser, block_given?

    input.each { |line|
      statement_parser.parse(line) { |context, *data|
        case context
          when :use
            name = data[0]
            yield context, name if block_given
          when :create
            table = data[0]
          when :column
            columns[table] << data[0] if table
          when :table
            yield context, name, table, columns[table] if block_given
            table = nil
          when :insert
            _table, _columns, _values = data

            _columns = _columns.nil? ? columns[_table] :
              _columns.gsub(CLEAN_COLUMNS_RE, '').split(',')

            value_parser.parse(_values) { |values|
              block[context, name, _table, _columns, values]
            } unless _columns.empty?
        end
      }
    }

    @name, @table = name, table

    self
  end

end

MySQLParser = MysqlParser

require_relative 'mysql_parser/statement_parser'
require_relative 'mysql_parser/value_parser'
require_relative 'mysql_parser/version'
