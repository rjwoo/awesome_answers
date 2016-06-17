class Question < ActiveRecord::Base
  # 'has_many' helps us set up the association between question model and the
  # answer model. In this case 'has_many' assumes that the answers table constraint
  # a field named 'question_id' that is an integer(this is a Rails convention)
  # the dependent option takes values like 'destroy' and 'nullify'
  # 'destroy' will make Rails automatically delete associated answers before deleting the question.
  # 'nullify' will make Rails turn 'question_id' values of associated records
  # to 'NULL' before deleting the question.
  has_many :answers, dependent: :destroy
  belongs_to :category
  belongs_to :user

  validates(:title, {presence: true, uniqueness: true})

  # by having the option: uniqueness: {scope: :title} it ensures that the body
  # must be unique in combination with the title.
  validates :body, presence:   true,
                   length:     {minimum: 7},
                   uniqueness: {scope: :title}

  validates :view_count, numericality: {greater_than_or_equal_to: 0}

  # VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # validates :email, format: VALID_EMAIL_REGEX

  validate :no_monkey
  validate :no_title_in_body

  after_initialize :set_defaults
  before_validation :cap_title, :squeeze_space
  # before_save      :cap_title
  # before_save      :squeeze_space

  # scope :search, lambda {|word| where("title ILIKE ? OR body ILIKE ?", "%#{word}%", "%#{word}%")}
  def self.search(word)
    where("title ILIKE ? OR body ILIKE ?", "%#{word}%", "%#{word}%")
  end

  # scope :recent, lambda {|count| where("created_at > ?", 3.days.ago).limit(count)}
  # def self.recent(count)
  #   where("created_at >?", 3.days.ago).limit(count)
  # end

  def new_first_answers
    answers.order(created_at: :desc)
  end

  private

  def squeeze_space
    self.title.squeeze!(" ") if title
    self.body.squeeze!(" ") if body
  end

  def cap_title
    self.title = title.capitalize if title
  end

  def set_defaults
    self.view_count ||= 0
  end

  def no_monkey
    if title && title.include?("monkey")
      errors.add(:title, "No monkey please!")
    end
  end

  def no_title_in_body
    if body.include?(title)
      errors.add(:body, "The title is in the body!")
    end
  end

end
