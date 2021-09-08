# frozen_string_literal: true

require "dry/cli"
require "json"
require "uptimerobot"

require_relative "uppityrobot/client"
require_relative "uppityrobot/version"
require_relative "uppityrobot/cli/commands/exec"
require_relative "uppityrobot/cli/commands/version"

# load the registry last
require_relative "uppityrobot/cli/commands/registry"

module Uppityrobot
  class Error < StandardError; end
  # Your code goes here...
end
