# frozen_string_literal: true

module UppityRobot
  module CLI
    module Commands
      # UppityRobot::CLI::Commands::Exec executes an API task
      class Exec < Dry::CLI::Command
        desc "Execute an API task"

        argument :task, required: true, values: UptimeRobot::Client::METHODS, desc: "API task to be executed"

        option   :data, type: :string, desc: "JSON data file"
        option   :params, type: :string, default: "{}", desc: "JSON params"

        example [
          "getMonitors --data $json_data_file",
          'getMonitors --params \'{"monitors": "123-456-789"}\''
        ]

        def call(task:, data: nil, params: "{}", **)
          task   = task.to_sym
          params = data.nil? ? JSON.parse(params) : parse_file(data)
          puts UppityRobot::Client.new(task, params).execute.to_json
        rescue JSON::ParserError => e
          puts JSON.generate({ stat: "fail", error: "JSON parser #{e.message}" })
        end

        def parse_file(file)
          JSON.parse(File.read(File.expand_path(file)))
        end
      end
    end
  end
end
