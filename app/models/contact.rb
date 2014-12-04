class Contact < ActiveRecord::Base
  belongs_to :user
  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name, length: { minimum: 2 }
  validates :last_name, length: { minimum: 2 }, allow_blank: true
  validates :email, length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX },
            allow_blank: true
  validates :phone, length: { maximum: 20 }, allow_blank: true
  validates :street, length: { maximum: 100 }, allow_blank: true
  validates :city, length: { maximum: 100 }, allow_blank: true
  validates :state, length: { maximum: 100 }, allow_blank: true
  validates :zip, length: { in: 5..10 }, allow_blank: true
  validates :country, length: { maximum: 100 }, allow_blank: true
end
