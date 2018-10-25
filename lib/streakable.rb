require "streakable/streak"
require "active_record"

module Streakable
  def self.included(klass)
    klass.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def streak(association, column=:created_at)
      Streak.new(self, association, column).length
    end
  end
end