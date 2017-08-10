class User < ActiveRecord::Base
  # Virtual attributes
  attr_accessor :current_password, :force_password_change, :skip_password_validation

  # Constants
  MINIMUM_PASSWORD_COMPLEXITY = 3
  MINIMUM_PASSWORD_LENGTH = 6

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { link: "/login", case_sensitive: false }
  validates_format_of :email, :with => /@/
  validate :check_current_password, on: :update, if: :should_check_current_password?
  validate :password_complexity, if: :password

  # Rails secure password
  has_secure_password

  # Callbacks
  before_create { generate_token(:auth_token) }

  # Class Methods
  def self.query_method
    'first_name ILIKE :query OR last_name ILIKE :query'
  end

  # Methods
  def to_s
    "User \"#{ full_name }\""
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def pretty_email
    "#{ full_name } <#{ email }>"
  end


  def assign_random_password
    self.password = SecureRandom.urlsafe_base64 + "Aa1"
  end


  private



  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def should_check_current_password?
    changes['password_digest'] && !force_password_change
  end

  def check_current_password
    unless BCrypt::Password.new(changes['password_digest'].first) == current_password
      errors.add(:current_password, I18n.t(:invalid))
    end
  end

  def password_complexity
    if skip_password_validation
      return
    end

    is_long_enough = password.length >= MINIMUM_PASSWORD_LENGTH
    has_downcase_letters = password.match(/[a-z]{1}/) ? 1 : 0
    has_uppercase_letters = password.match(/[A-Z]/) ? 1 : 0
    has_digits = password.match(/\d/) ? 1 : 0

    score = has_downcase_letters + has_uppercase_letters + has_digits

    unless is_long_enough && score == MINIMUM_PASSWORD_COMPLEXITY
      errors.add(:password, I18n.t(:is_not_complex_enough))
    end
  end

end
