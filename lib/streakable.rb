require "streakable/streak"
require "active_record"

module Streakable
  VERSION = "0.0.6"

  def self.included(klass)
    klass.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def streak(association)
      Streak.new(self, association).length
    end
  end
end