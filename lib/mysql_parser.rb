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

  USE_RE           = /\AUSE\s+`(.+?)`/i
  CREATE_TABLE_RE  = /\ACREATE\s+TABLE\s+`(.+?)`/i
  TABLE_COLUMN_RE  = /\A\s+`(.+?)`/
  FINISH_TABLE_RE  = /\A\).*;\Z/
  INSERT_VALUES_RE = /\AINSERT\s+INTO\s+`(.+?)`\s+(?:\((.+?)\)\s+)?VALUES\s*(.*);\Z/i
  CLEAN_COLUMNS_RE = /[\s`]+/

  def self.parse(input, &block)
    parser = new.parse(input, &block)
    block ? parser : parser.tables
  end

  def initialize
    reset
  end

  def reset
    @name         = DEFAULT_NAME
    @table        = DEFAULT_TABLE
    @tables       = {}
    @columns      = Hash.new { |h, k| h[k] = [] }
    @value_parser = ValueParser.new
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

    name, table, columns, value_parser, block_given =
      @name, @table, @columns, @value_parser, block_given?

    input.each { |line|
      case line
        when USE_RE
          name = $1
          yield :use, name if block_given
        when CREATE_TABLE_RE
          table = $1
        when TABLE_COLUMN_RE
          columns[table] << $1 if table
        when FINISH_TABLE_RE
          yield :table, name, table, columns[table] if block_given
          table = nil
        when INSERT_VALUES_RE
          _table, _columns, _values = $1, $2, $3

          _columns = _columns.nil? ? columns[_table] :
            _columns.gsub(CLEAN_COLUMNS_RE, '').split(',')

          value_parser.parse(_values) { |values|
            block[:insert, name, _table, _columns, values]
          } unless _columns.empty?
      end
    }

    @name, @table = name, table

    self
  end

end

MySQLParser = MysqlParser

require_relative 'mysql_parser/value_parser'
require_relative 'mysql_parser/version'
