class User < ApplicationRecord #>
  has_secure_password

  acts_as_voter
  acts_as_followable
  acts_as_follower
  has_many :tweets, dependent: :destroy

  validates_length_of(
    :password,
    maximum: 72,
    minimum: 8,
    allow_nil: true,
    allow_blank: false
  )

  validates_presence_of(
    :name,
    :email
  )
end
