class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :email, type: String
  field :password_hash, type: String
  field :password_salt, type: String
  field :admin, type: Boolean

  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def self.authenticate(email, password)
    user = where(email: email).first
    if( user && user.password_hash == BCrypt::Engine
      .hash_secret(password, user.password_salt)
    )
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine
        .hash_secret(password, password_salt)
    end
  end

  def equipment_reservations
    EquipmentReservation.where(user: _id)
  end
end
