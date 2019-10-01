require 'coveralls'
Coveralls.wear!

require "active_support"
require "streakable"
require "database_cleaner"
require "pry"
require "support/database_cleaner"
require "support/user"
require "support/post"
require "sqlite3"
require "timecop"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define do
  self.verbose = true

  create_table :users, force: true do |t|
    t.string :name
    t.timestamps
  end

  create_table :posts, force: true do |t|
    t.string :content
    t.integer :user_id
    t.timestamps
  end
end
