class Article < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
end
