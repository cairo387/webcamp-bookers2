class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include JpPrefecture
  jp_prefecture :prefecture_code

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォロー取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy #フォロワー取得
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人

  attachment :profile_image

  validates :name, uniqueness: true, length: {minimum: 2, maximum:20 }
  validates :introduction, length: { maximum: 50 }
  validates :postal_code, presence: true
  validates :prefecture_code, presence: true
  validates :address_city, presence: true
  validates :address_street, presence: true

  #ユーザーをフォローする
  def follow(other_user)
    follower.create(followed_id: other_user.id)
  end

  #ユーザーのフォローを外す
  def unfollow(other_user)
    follower.find_by(followed_id: other_user.id).destroy
  end

  #フォローしていればtrueを返す
  def following?(other_user)
    following_user.include?(other_user)
  end

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  def self.search(type, search)
    if type == "exact"
      @users = User.where(name: search)
    elsif type == "prefix"
      @users = User.where("name LIKE?", "#{search}%")
    elsif type == "backward"
      @users = User.where("name LIKE?", "%#{search}")
    elsif type == "partial"
      @users = User.where("name LIKE?", "%#{search}%")
    else
      @users = User.all
    end
  end
end
