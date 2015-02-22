module ActiveRecord
  module PostgreSQL
    module Expression
      class Railtie < Rails::Railtie
        initializer 'activerecord-postgresql-expression' do
          ActiveSupport.on_load :active_record do
            require 'activerecord/postgresql/expression/base'
          end
        end
      end
    end
  end
end
