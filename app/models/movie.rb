class Movie < ActiveRecord::Base
    
    scope :sort_title, lambda {order(:title)}
    scope :sort_release_date, lambda {order(:release_date)}
    scope :unique_ratings, lambda {uniq.pluck(:rating).sort}
    scope :filter_ratings, lambda { |ratings| where(:rating => ratings)}
    
end
