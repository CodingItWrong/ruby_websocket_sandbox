# frozen_string_literal: true

require 'active_record'

class User < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true
end
