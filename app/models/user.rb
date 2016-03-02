class User < ActiveRecord::Base
  before_save {self.email = email.downcase}
  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.{1}]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum:255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  #rails在数据库层加唯一性限制，其实就是给需要唯一性限制的列加上索引，然后给索引再加上唯一性限制就可以了。
  has_secure_password #密码哈希值和密码摘要其实是一个意思
  validates :password, presence: true, length: { minimum: 6 }
end
