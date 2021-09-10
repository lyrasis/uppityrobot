# frozen_string_literal: true

module UppityRobot
  module CLI
    # UppityRobot::CLI::Commands Registry
    module Commands
      extend Dry::CLI::Registry

      register "exec", Exec, aliases: ["e"]
      register "version", Version, aliases: ["v", "-v", "--version"]

      register "monitors", aliases: ["m"] do |prefix|
        prefix.register "create", Monitors::Create
        prefix.register "delete", Monitors::Delete
        prefix.register "exec",   Monitors::Exec
        prefix.register "list",   Monitors::List
      end
    end
  end
end
