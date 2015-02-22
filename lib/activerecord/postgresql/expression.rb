require 'active_support'

begin
  require 'rails'
rescue LoadError
  # nothing to do! yay!
end

if defined? Rails
  require 'activerecord/postgresql/expression/railtie'
else
  ActiveSupport.on_load :active_record do
    require 'activerecord/postgresql/expression/base'
  end
end
