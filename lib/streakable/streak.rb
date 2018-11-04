# Represents a streak of calendar days as computed
# by a date column on an association.
#
# @example
#
# So for example if you have a User that has_many :posts, then
# +Streak.new(user, :posts, :created_at).length+ will tell you how many
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
  def initialize(instance, association, column, except_today: false)
    @instance = instance
    @association = association
    @column = column
    # Don't penalize the current day being absent when determining streaks
    @except_today = except_today
  end

  # Calculate the length of this calendar day streak
  # 
  # @param [Boolean] longest if true, calculate the longest day streak in the sequence, 
  # not just the current one
  def length(longest: false)
    if streaks.empty?
      0
    elsif longest
      streaks.sort.first.size
    else
      streak = streaks.first
      if streak.include?(Date.current) || except_today && streak.include?(Date.yesterday)
        streak.size
      else
        0
      end
    end
  end

  # Get a list of all calendar day streaks, sorted descending 
  # (from most recent to farthest away)
  # Includes 1-day streaks. If you want to filter
  # the results further, for example if you want 2 only
  # include 2+ day streaks, you'll have to filter on the result
  def streaks
    return [] if days.empty?

    streaks = []
    streak = []
    days.each.with_index do |day, i|
      # first day
      if i == 0
        # since this is the first one,
        # push to our new streak
        streak << day

      # consecutive day, the previous day was "tomorrow" 
      # relative to day (since we're date descending)
      elsif days[i-1] == day.tomorrow
        # push to existing streak
        streak << day

      # streak was broken
      else
        # push our current streak
        streaks << streak

        # start a new streak
        # and push day to our new streak
        streak = []
        streak << day
      end

      # the jig is up, push the current streak
      if i == (days.size-1) 
        streaks << streak 
      end
    end

    streaks
  end

  private
    def days
      @days ||= instance.send(association).order(column => :desc).pluck(column).map(&:to_date).uniq
    end
end