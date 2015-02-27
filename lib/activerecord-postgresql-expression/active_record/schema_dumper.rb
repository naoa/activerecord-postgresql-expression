require 'active_record/schema_dumper'

module ActiveRecord
  module PostgreSQL
    module Expression
      module SchemaDumper
        private
        def indexes(table, stream)
          buf = StringIO.new
          super(table, buf)
          output = add_index_with_expression(table)
          if output == ""
            buf = buf.string
            stream.print buf
          else
            buf = buf.string.chomp
            stream.print buf
            stream.print output + "\n\n"
          end
          stream
        end

        def add_index_with_expression(table)
          result = @connection.query(<<-SQL, 'SCHEMA')
            SELECT distinct i.relname, pg_get_expr(d.indexprs, d.indrelid)
            FROM pg_class t
            INNER JOIN pg_index d ON t.oid = d.indrelid
            INNER JOIN pg_class i ON d.indexrelid = i.oid
            WHERE i.relkind = 'i'
            AND d.indisprimary = 'f'
            AND t.relname = '#{table}'
            AND i.relnamespace IN (SELECT oid FROM pg_namespace WHERE nspname = ANY (current_schemas(false)) )
            AND d.indexprs IS NOT NULL
            ORDER BY i.relname
          SQL
          add_index_statements = result.map do |row|
            index_name = row[0]
            expression = row[1]
            column_name = guess_column_name(index_name)
            statement_parts = [
              " add_index #{remove_prefix_and_suffix(table).inspect}",
              "#{column_name}",
              "name: #{index_name.inspect}",
              "using: :gin",
              "expression: #{expression.inspect}"
            ]
            " #{statement_parts.join(', ')}"
          end
          add_index_statements.sort.join("\n")
        end
        def guess_column_name(index_name)
          if matched = index_name.match(/_on_(?<name>.*)$/)
            column_name = "[#{matched[:name].inspect}]"
          else
            column_name = "''"
          end
        end
      end
    end
  end

  class SchemaDumper #:nodoc:
    prepend PostgreSQL::Expression::SchemaDumper
  end
end
