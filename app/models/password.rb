class Password
  include ActiveModel::API

  attr_accessor :has_secure_password, :current_password, :password, :password_confirmation

  validates_presence_of :has_secure_password, :current_password
  validate :current_password_is_correct

  validates :password, presence: true, length: {minimum: 8, maximum: 72}
  validate :password_matches_confirmation

  def save
    validity = valid?
    return validity unless validity

    has_secure_password.password = password
    has_secure_password.password_confirmation = password_confirmation
    has_secure_password.save
  end

  private

  def current_password_is_correct
    unless has_secure_password&.authenticate(current_password)
      errors.add(:current_password, "is incorrect")
    end
  end

  def password_matches_confirmation
    if password != password_confirmation
      errors.add(:password_confirmation, "doesn't match the password")
    end
  end
end
