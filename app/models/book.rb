class Book < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search(type, search)
    if type == "exact"
      @books = Book.where(title: search)
    elsif type == "prefix"
      @books = Book.where("title LIKE?", "#{search}%")
    elsif type == "backward"
      @books = Book.where("title LIKE?", "%#{search}")
    elsif type == "partial"
      @books = Book.where("title LIKE?", "%#{search}%")
    else
      @books = Book.all
    end
  end

end