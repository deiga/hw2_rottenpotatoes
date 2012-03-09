class Movie < ActiveRecord::Base

  def self.all_ratings
    ratings = []
    self.select(:rating).uniq.each { |model| ratings << model.rating.to_s }
    ratings & ratings
  end
end
