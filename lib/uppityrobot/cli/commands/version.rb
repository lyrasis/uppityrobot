# frozen_string_literal: true

module UppityRobot
  module CLI
    module Commands
      # UppityRobot::CLI::Commands::Version prints version
      class Version < Dry::CLI::Command
        desc "Print UppityRobot CLI tool version"

        def call(*)
          puts Uppityrobot::VERSION
        end
      end
    end
  end
end
