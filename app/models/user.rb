class User < ActiveRecord::Base
  # has_secure_password will give us functionalities needed for user authentication:
  # 1 - It will add attribute accessors: password, password_confirmation
  # 2 - It will add a validation for password presence and length of password (4..72)
  # 3 - If password_confirmation is set, it will validate that it's the same as password
  # 4 - It will add handy methods for us to automatically hash the password to the password_digest field and compare a given password
  has_secure_password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  has_many :questions, dependent: :nullify

  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question

  has_many :votes, dependent: :destroy
  has_many :voted_questions, through: :votes, source: :question

  def full_name
    "#{first_name} #{last_name}"
  end

end
