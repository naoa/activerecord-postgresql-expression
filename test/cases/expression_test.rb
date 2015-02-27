require 'cases/helper'
require 'support/schema_dumping_helper'

class ExpressionTest < ActiveRecord::TestCase
  include SchemaDumpingHelper

  class Expression < ActiveRecord::Base
  end

  setup do
    @connection = ActiveRecord::Base.connection
    @connection.create_table("gin_and_btree", force: true) do |t|
      t.string "title"
      t.text "content"
    end
    @connection.add_index :gin_and_btree, :content, using: :gin, expression: 'to_tsvector(\'english\'::regconfig, (content)::text)'
    @connection.add_index :gin_and_btree, :content, name: 'hogehoge', using: :gin, expression: 'to_tsvector(\'english\'::regconfig, (content)::text)'
    @connection.add_index :gin_and_btree, :title
    @connection.create_table("no_index", force: true) do |t|
      t.string "title"
      t.text "content"
    end
    @connection.create_table("btree", force: true) do |t|
      t.string "title"
      t.text "content"
    end
    @connection.add_index :btree, :title
    @connection.create_table("gin", force: true) do |t|
      t.string "title"
      t.text "content"
    end
    @connection.add_index :gin, :content, using: :gin, expression: 'to_tsvector(\'english\'::regconfig, (content)::text)'
  end

  teardown do
    @connection.drop_table "gin_and_btree"
    @connection.drop_table "btree"
    @connection.drop_table "gin"
    @connection.drop_table "no_index"
  end

  def test_schema_dump_gin_and_btree
    schema = dump_table_schema "gin_and_btree"
    assert_match %r{add_index\s+\"gin_and_btree\",\s+\[\"title\"\],\s+name:\s+\"index_gin_and_btree_on_title\",\s+using:\s+:btree$}, schema
    assert_match %r{add_index\s+\"gin_and_btree\",\s+\[\"content\"\],\s+name:\s+\"index_gin_and_btree_on_content\",\s+using:\s+:gin,\s+expression:\s+\"to_tsvector\('english'::regconfig,\s+content\)\"$}, schema
    assert_match %r{add_index\s+\"gin_and_btree\",\s+'',\s+name:\s+\"hogehoge\",\s+using:\s+:gin,\s+expression:\s+\"to_tsvector\('english'::regconfig,\s+content\)\"$}, schema
    assert_match %r{\n\nend$}, schema
  end
  def test_schema_dump_gin
    schema = dump_table_schema "gin"
    assert_match %r{\n\nend$}, schema
  end
  def test_schema_dump_btree
    schema = dump_table_schema "btree"
    assert_match %r{\n\nend$}, schema
  end
  def test_schema_dump_no_index
    schema = dump_table_schema "no_index"
    assert_match %r{end\n\nend$}, schema
  end
end
