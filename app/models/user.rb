class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  validates :username,
  :presence => true,
  :length => { minimum: 6},
  :uniqueness => {
    :case_sensitive => false
  } # etc.

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:username]

  validates_uniqueness_of :email, :allow_blank => true

  def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value", { :value => login.downcase }]).first
      else
        where(conditions.to_h).first
      end
  end

  protected
  def email_required?
    false
  end
end
