class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tenders
  has_many :submissions
  has_many :tenders_as_bidder, through: :submissions, source: :tender
  has_many :employees
  has_many :compatible_responses, through: :submissions
  validates :company_name, presence: true
  validates :email, presence: true
  validates :address, presence: true
end
