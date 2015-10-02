#--
###############################################################################
#                                                                             #
# mysql_parser -- Parse MySQL statements                                      #
#                                                                             #
# Copyright (C) 2014-2015 Jens Wille                                          #
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

require 'strscan'

class MysqlParser

  class ValueParser

    Node = Struct.new(:value)

    def self.parse(input)
      new.parse(input)
    end

    def parse(input)
      @input = StringScanner.new(input)

      rows, block_given = [], block_given?

      while result = parse_row
        row = result.value
        block_given ? yield(row) : rows << row
        break unless @input.scan(/,\s*/)
      end

      @input.skip(/;/)

      error('Unexpected data') unless @input.eos?

      rows unless block_given
    end

    def parse_row
      return unless @input.scan(/\(/)

      row = []

      while result = parse_value
        row << result.value
        break unless @input.scan(/,\s*/)
      end

      error('Unclosed row') unless @input.scan(/\)/)

      Node.new(row)
    end

    def parse_value
      parse_string ||
      parse_number ||
      parse_keyword
    end

    def parse_string
      return unless @input.scan(/'/)

      string = ''

      while contents = parse_string_content || parse_string_escape
        string << contents.value
      end

      error('Unclosed string') unless @input.scan(/'/)

      Node.new(string)
    end

    def parse_string_content
      if @input.scan(/[^\\']+/)
        Node.new(@input.matched)
      end
    end

    def parse_string_escape
      if @input.scan(/\\[abtnvfr]/)
        Node.new(eval(%Q{"#{@input.matched}"}))
      elsif @input.scan(/\\.|''/)
        Node.new(@input.matched[-1, 1])
      end
    end

    def parse_number
      if @input.scan(/-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?/)
        Node.new(eval(@input.matched))
      end
    end

    def parse_keyword
      if @input.scan(/null/i)
        Node.new(nil)
      end
    end

    def error(message)
      raise @input.eos? ? "Unexpected end of input (#{message})." :
        "#{message} at #{$.}:#{@input.pos}: #{@input.peek(16).inspect}"
    end

  end

end
