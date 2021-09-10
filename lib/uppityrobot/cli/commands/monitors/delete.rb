# frozen_string_literal: true

module UppityRobot
  module CLI
    module Commands
      module Monitors
        # UppityRobot::CLI::Commands::Monitors::Delete delete a monitor
        class Delete < Dry::CLI::Command
          desc "Delete a monitor"

          argument :field, required: true, values: %w[id name], desc: "The field used to target the monitor"
          argument :value, required: true, type: Integer, desc: "The field value"

          example [
            "id 1",
            "name aspace"
          ]

          def call(field:, value:, **)
            check_field(field)
            monitor = find_monitor(field, value)
            response = UppityRobot::Client.new(:deleteMonitor, { id: monitor["id"] }).execute
            puts response.to_json
          end

          def check_field(field)
            return if %w[id name].include? field

            abort({ stat: "fail",
                    error: "Field not recognized, must be one of: [id, name]" }.to_json)
          end

          def find_monitor(field, value)
            params = {}
            case field
            when "id"
              params[:monitors] = value
            when "name"
              params[:search] = value
            end
            UppityRobot::Client.new(:getMonitors, params).fetch
          end
        end
      end
    end
  end
end
