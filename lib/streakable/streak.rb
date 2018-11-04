# Represents a streak of calendar days as computed
# by a date column on an association.
#
# @example
#
# So for example if you have a User that has_many :posts, then
# +Streak.new(user :posts, :created_at).length+ will tell you how many
# consecutive days a given user created posts.
class Streak
  # the base ActiveRecord object instance for this streak calculation
  attr_reader :instance

  # the AR association through which we want to grab a column to caculate a streak
  attr_reader :association

  # an AR column resolving to a date. the column that we want to calculate a calendar date streak against
  attr_reader :column

  # whether to include today in the streak length 
  # calculation or not. If this is true, then you are assuming there 
  # is still time today for the streak to be extended
  attr_reader :except_today

  # Creates a new Streak.
  # @param [ActiveRecord::Base] instance an ActiveRecord object instance
  #
  # @param [Symbol] association a key representing the ActiveRecord association 
  # on the instance
  #
  # @param [Symbol] column a key representing the column on the association 
  # that you want to calculate the streak against
  #
  # @param [Boolean] except_today whether to include today in the streak length 
  # calculation or not. If this is true, then you are assuming there 
  # is still time today for the streak to be extended
  def initialize(instance, association, column, except_today)
    @instance = instance
    @association = association
    @column = column
    # Don't penalize the current day being absent when determining streaks
    @except_today = except_today
  end

  # Calculate the length of this calendar day streak
  def length
    @length ||= begin
      val = 0
      streak_map.each do |map_bool|
        break if !map_bool
        val += 1
      end

      val
    end
  end

  private
    def days
      @days ||= instance.send(association).order(column => :desc).pluck(column).map(&:to_date).uniq
    end

    def streak_map
      @streak_map || begin
        days.map.with_index do |day, i|
          if i == 0
            streak_day(day)
          else
            days[i-1] == day.tomorrow
          end
        end
      end
    end

    def streak_day(day)
      if !except_today
        day == Date.current
      else
        day == Date.current ||
        day == Date.yesterday
      end
    end
end