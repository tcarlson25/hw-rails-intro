class Movie < ActiveRecord::Base
    
    scope :sort_by, lambda { |attribute| order(attribute)}
    scope :unique_ratings, lambda {uniq.pluck(:rating).sort}
    scope :filter_ratings, lambda { |ratings, movies| movies.where(:rating => ratings)}
    
end
