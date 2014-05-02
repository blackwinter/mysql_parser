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

  class StatementParser

    QUOTED_NAME_RE = %r{
      `
      ( .*? )
      `
    }xi

    USE_RE = %r{
      \A
      USE
      \s+
      #{QUOTED_NAME_RE}
    }xi

    CREATE_TABLE_RE = %r{
      \A
      CREATE \s+ TABLE
      \s+
      #{QUOTED_NAME_RE}
    }xi

    TABLE_COLUMN_RE = %r{
      \A
      \s+
      #{QUOTED_NAME_RE}
    }xi

    FINISH_TABLE_RE = %r{
      \A
      \)
      .*
      ;
      \Z
    }xi

    INSERT_VALUES_RE = %r{
      \A
      INSERT \s+ INTO
      \s+
      #{QUOTED_NAME_RE}
      \s+
      (?:
        \(
        ( .+? )
        \)
        \s+
      )?
      VALUES
      \s*
      ( .* )
      ;
      \Z
    }xi

    def self.parse(input)
      new.parse(input)
    end

    def parse(input)
      case input
        when USE_RE           then yield :use,    $1
        when CREATE_TABLE_RE  then yield :create, $1
        when TABLE_COLUMN_RE  then yield :column, $1
        when FINISH_TABLE_RE  then yield :table
        when INSERT_VALUES_RE then yield :insert, $1, $2, $3
      end
    end

  end

end
