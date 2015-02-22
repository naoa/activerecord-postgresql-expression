if ActiveRecord::VERSION::MAJOR == 4
  require 'activerecord-postgresql-expression/active_record/schema_dumper'
  require 'activerecord-postgresql-expression/active_record/connection_adapters/postgresql/schema_statements'
else
  raise "activerecord-postgresql-expression supports activerecord ~> 4.x"
end
