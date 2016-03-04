class User < ActiveRecord::Base
  attr_accessor :remember_token

  before_save {email.downcase!}
  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum:255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  #rails在数据库层加唯一性限制，其实就是给需要唯一性限制的列加上索引，然后给索引再加上唯一性限制就可以了。
  has_secure_password #密码哈希值和密码摘要其实是一个意思
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  #返回指定字符串的哈希摘要
  #def User.digest(string)
    #cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    #BCrypt::Password.create(string, cost: cost)
  #end

  #返回指定字符串的哈希摘要 的另一种写法
  #def self.digest(string)
  #  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  #  BCrypt::Password.create(string, cost: cost)
  #end

  #返回指定字符串的哈希摘要 的第三种写法
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #返回一个随机令牌
  #def User.new_token
  #  SecureRandom.urlsafe_base64
  #end

  #返回一个随机令牌的另一种写法
  #def self.new_token
  #  SecureRandom.urlsafe_base64
  #end

  #返回一个随机令牌的第三种写法
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  #为了持久会话，我们在数据库中记住用户
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #如果指定的令牌和摘要匹配返回true
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
