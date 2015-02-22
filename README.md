# ActiveRecord::PostgreSQL::Expression

[![Build Status](https://travis-ci.org/naoa/activerecord-postgresql-expression.png?branch=master)](https://travis-ci.org/naoa/activerecord-postgresql-expression)

Adds expression to migrations for ActiveRecord PostgreSQL adapters

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-postgresql-expression'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-postgresql-expression

## Usage

```ruby
bundle exec rails g migration CreatePosts
```

```ruby
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text   :content
      t.timestamps
    end
    add_index :posts, :content, using: :gin, expression: 'to_tsvector(\'english\'::regconfig, (content)::text)'
  end
end
```

```ruby
bundle exec rake db:migrate
```

## Contributing

1. Fork it ( https://github.com/naoa/activerecord-postgresql-expression/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

