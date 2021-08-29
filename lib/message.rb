# frozen_string_literal: true

require 'active_record'

class Message < ActiveRecord::Base
  validates :contents, presence: true
end
