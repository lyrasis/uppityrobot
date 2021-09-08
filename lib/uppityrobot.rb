# frozen_string_literal: true

require "dry/cli"
require "json"
require "uptimerobot"

require_relative "uppityrobot/client"
require_relative "uppityrobot/version"

module Uppityrobot
  class Error < StandardError; end
  # Your code goes here...
end
