# app/models/membership.rb
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :community
end
