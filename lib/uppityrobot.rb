# frozen_string_literal: true

require "csv"
require "dry/cli"
require "json"
require "uptimerobot"

require_relative "uppityrobot/client"
require_relative "uppityrobot/version"
require_relative "uppityrobot/cli/commands/exec"
require_relative "uppityrobot/cli/commands/monitors/create"
require_relative "uppityrobot/cli/commands/monitors/delete"
require_relative "uppityrobot/cli/commands/monitors/exec"
require_relative "uppityrobot/cli/commands/monitors/list"
require_relative "uppityrobot/cli/commands/monitors/update"
require_relative "uppityrobot/cli/commands/version"

# load the registry last
require_relative "uppityrobot/cli/commands/registry"

module UppityRobot
  class Error < StandardError; end

  ROOT = Gem::Specification.find_by_name("uppityrobot").gem_dir
end
