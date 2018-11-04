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
    # For example if you have a User with many :posts, and one was created
    # today that would be a streak of 1. If that user also created a Post yesterday,
    # then the streak would be 2. If he created another Post the day before that one,
    # he'd have a streak of 3, etc.
    # 
    # On the other hand imagine that the User hasn't created a Post yet today, but
    # he did create one yesterday. Is that a streak? By default, it would be a streak of 0,
    # so no. If you want to exclude the current day from this calculation, and count from
    # yesterday, set +except_today+ to +true+.
    # 
    # @param [Symbol] association the ActiveRecord association on the instance
    # @param [Symbol] column the column on the association that you want to calculate the streak against.
    # @param [Boolean] except_today whether to include today in the streak length calculation or not. If this is true, then you are assuming there is still time today for the streak to be extended
    # @param [Boolean] longest if true, calculate the longest day streak in the sequence, not just the current one
    def streak(association, column=:created_at, except_today: false, longest: false)
      build_streak(association, column, except_today: except_today).length(longest: longest)
    end

    # Calculate all calendar streaks. Returns a list of Date arrays. That is to say, a listing of consecutive
    # days counts that exist for some date column, on an asociation with this object.
    # 
    # @param [Symbol] association the ActiveRecord association on the instance
    # @param [Symbol] column the column on the association that you want to calculate the streak against.
    # @param [Boolean] except_today whether to include today in the streak length calculation or not. If this is true, then you are assuming there is still time today for the streak to be extended
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