class Staff < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tickets

  def full_name
    "#{first_name} #{last_name}"
  end
end
