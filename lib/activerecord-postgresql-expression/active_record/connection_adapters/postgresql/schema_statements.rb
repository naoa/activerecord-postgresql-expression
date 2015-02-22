require 'active_record/connection_adapters/postgresql/schema_statements'

module ActiveRecord
  module PostgreSQL
    module Expression
      module SchemaStatements
        def add_index_options(table_name, column_name, options = {})
          if options.key?(:expression)
            expression = options[:expression]
            options.delete(:expression)
          end

          index_name, index_type, index_columns, index_options, algorithm, using = super

          if expression.present?
            index_columns = expression
          end

          [index_name, index_type, index_columns, index_options, algorithm, using]
        end
      end
    end
  end

  module ConnectionAdapters
    class PostgreSQLAdapter < AbstractAdapter
      prepend ActiveRecord::PostgreSQL::Expression::SchemaStatements
    end
  end
end
