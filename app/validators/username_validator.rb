class UsernameValidator < ActiveModel::Validator
  def validate(record)
    return if record.username.nil?
    unless record.username =~ /\A[a-zA-Z0-9_]+\Z/
      record.errors[:username] << "must contain only alphanumeric or the characters: '_'"
    end
  end
end
