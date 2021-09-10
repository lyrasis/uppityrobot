# frozen_string_literal: true

module UppityRobot
  module CLI
    module Commands
      module Monitors
        # UppityRobot::CLI::Commands::Monitors::Exec pauses or starts monitors
        class Exec < Dry::CLI::Command
          desc "Execute a pause or start request for monitors"

          argument :task, required: true, values: %w[pause start], desc: "Pause or Start monitors"
          argument :search, required: true, desc: "Search term for monitors"

          option :filter, type: :string, default: "{}", desc: "Filter string for monitors"

          example [
            "pause aspace",
            'start aspace --filter \'{"status": 0}\''
          ]

          # rubocop:disable Metrics/AbcSize
          def call(task:, search:, filter: "{}", **)
            status   = check_task(task)
            filter   = JSON.parse(filter)
            filtered = { stat: "ok", total: 0, monitors: [] }
            params   = { search: search }
            total    = 0

            UppityRobot::Client.new(:getMonitors, params).filter(filter).each do |m|
              data = { id: m["id"], status: status }
              filtered[:monitors] << UppityRobot::Client.new(:editMonitor, data).execute
              total += 1
            end

            filtered[:total] = total
            puts filtered.to_json
          rescue JSON::ParserError => e
            puts JSON.generate({ stat: "fail", error: "JSON parser #{e.message}" })
          end
          # rubocop:enable Metrics/AbcSize

          def check_task(task)
            case task.downcase
            when "pause"
              UptimeRobot::Monitor::Status::Paused
            when "start"
              UptimeRobot::Monitor::Status::NotCheckedYet
            else
              abort({ stat: "fail",
                      error: "Task not recognized, must be one of: [pause, start]" }.to_json)
            end
          end
        end
      end
    end
  end
end
