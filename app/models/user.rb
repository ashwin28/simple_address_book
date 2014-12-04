class User < ActiveRecord::Base
  has_many :contacts, -> { order('first_name ASC, last_name ASC') }

  has_secure_password

  validates :username, presence: true, uniqueness: { case_sensitive: true }
  validates :password, length: { minimum: 8 }
  validates :name, length: { minimum: 2 }, allow_blank: true

  # returns user given correct password
  def self.authenticate(username, password)
    user = find_by_username(username)
    return user if user && user.authenticate(password)
  end
end
