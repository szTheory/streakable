class Streak
  attr_reader :instance, :association, :column
  def initialize(instance, association, column: :created_at)
    @instance = instance
    @association = association
    @column = column
  end

  def length
    determine_consecutive_days
  end

  private
    def days
      @days ||= instance.send(association).order("created_at DESC").pluck(column).map(&:to_date).uniq
    end

    def determine_consecutive_days
      streak = first_day_in_collection_is_today? ? 1 : 0
      days.each_with_index do |day, index|
        break unless first_day_in_collection_is_today?
        if days[index+1] == day.yesterday
          streak += 1
        else
          break
        end
      end
      streak
    end

    def first_day_in_collection_is_today?
      days.first == Date.current
    end
end