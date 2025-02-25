class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tenders
  has_many :submissions
  validates :company_name, presence: true
  validates :email, presence: true
  validates :address, presence: true

end
