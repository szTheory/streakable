class User < ActiveRecord::Base
  has_many :posts

  include Streakable
end
