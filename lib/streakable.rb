require "streakable/streak"
require "active_record"

# Let's say I have a +User+ that +has_many+ posts:
# 
#   class User < ActiveRecord::Base
#     has_many :posts
#   end
#
# I want to track how many days in a row that each user wrote a post. I just have to +include Streakable+ in the model:
# 
#   class User < ActiveRecord::Base
#     include Streakable
#   end
#
# Now I can display the user's streak:
#   user.streak(:posts) # => number of days in a row that this user wrote a post (as determined by the created_at column, by default)
# 
# The +streak+ instance method can be called with any association:
#   user.streak(:other_association)
# 
# And you can change the column the streak is calculated on:
#   user.streak(:posts, :updated_at)
# 
# Don't penalize the current day being absent when determining streaks (the User could write another Post before the day ends):
#   user.streak(:posts, except_today: true)
module Streakable
  def self.included(klass)
    klass.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods # :nodoc:
    # Calculate a calendar streak. That is to say, the number of consecutive
    # days that exist for some date column, on an asociation with this object.
    # 
    # @param [Symbol] association the ActiveRecord association 
    # on the instance
    #
    # @param [Symbol] column the column on the association 
    # that you want to calculate the streak against.
    #
    # @param [Boolean] except_today whether to include today in the streak length 
    # calculation or not. If this is true, then you are assuming there 
    # is still time today for the streak to be extended
    #
    # @param [Boolean] longest if true, calculate the longest day streak in the sequence, not just the current one
    def streak(association, column=:created_at, except_today: false, longest: false)
      build_streak(association, column, except_today: except_today).length(longest: longest)
    end

    # Calculate all calendar streaks. That is to say, the map of consecutive
    # days counts that exist for some date column, on an asociation with this object.
    # 
    # @param [Symbol] association the ActiveRecord association 
    # on the instance
    #
    # @param [Symbol] column the column on the association 
    # that you want to calculate the streak against.
    #
    # @param [Boolean] except_today whether to include today in the streak length 
    # calculation or not. If this is true, then you are assuming there 
    # is still time today for the streak to be extended
    #
    # @param [Boolean] longest if true, calculate the longest day streak in the sequence, not just the current one
    def streaks(association, column=:created_at)
      build_streak(association, column, except_today: true).streaks
    end

    private
      def build_streak(association, column, except_today:)
        Streak.new(self, association, column, except_today: except_today)
      end
  end
end