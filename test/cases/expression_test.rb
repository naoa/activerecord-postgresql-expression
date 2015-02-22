require 'cases/helper'
require 'support/schema_dumping_helper'

class ExpressionTest < ActiveRecord::TestCase
  include SchemaDumpingHelper

  class Expression < ActiveRecord::Base
  end

  setup do
    @connection = ActiveRecord::Base.connection
    @connection.create_table("posts", force: true) do |t|
      t.string "title"
      t.text "content"
    end
    @connection.add_index :posts, :content, using: :gin, expression: 'to_tsvector(\'english\'::regconfig, (content)::text)'
    @connection.add_index :posts, :content, name: 'hogehoge', using: :gin, expression: 'to_tsvector(\'english\'::regconfig, (content)::text)'
    @connection.add_index :posts, :title
  end

  teardown do
    @connection.drop_table "posts"
  end

  def test_schema_dump_expression
    schema = dump_table_schema "posts"
    assert_match %r{add_index\s+\"posts\",\s+\[\"title\"\],\s+name:\s+\"index_posts_on_title\",\s+using:\s+:btree$}, schema
    assert_match %r{add_index\s+\"posts\",\s+\[\"content\"\],\s+name:\s+\"index_posts_on_content\",\s+using:\s+:gin,\s+expression:\s+\"to_tsvector\('english'::regconfig,\s+content\)\"$}, schema
    assert_match %r{add_index\s+\"posts\",\s+'',\s+name:\s+\"hogehoge\",\s+using:\s+:gin,\s+expression:\s+\"to_tsvector\('english'::regconfig,\s+content\)\"$}, schema
  end
end
