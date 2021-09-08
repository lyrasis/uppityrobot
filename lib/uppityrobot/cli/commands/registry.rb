# frozen_string_literal: true

module UppityRobot
  module CLI
    module Commands
      extend Dry::CLI::Registry

      register "version", Version, aliases: ["v", "-v", "--version"]
    end
  end
end
