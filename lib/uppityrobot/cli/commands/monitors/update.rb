# frozen_string_literal: true

module UppityRobot
  module CLI
    module Commands
      module Monitors
        # UppityRobot::CLI::Commands::Monitors::Update update monitors
        class Update < Dry::CLI::Command
          desc "Update monitors"

          argument :format, required: true, values: %w[csv json], desc: "The format to use for updates"
          argument :data, required: true, desc: "The data file or (json) string for updates"

          example [
            "csv monitors.csv",
            "json monitors.json",
            'json \'[{"id": 1, "friendly_name": "newName"}]\''
          ]

          # rubocop:disable Metrics/AbcSize
          def call(format:, data:, **)
            check_format(format)
            data = parse_data(format, data)
            unless data.is_a? Array
              abort(
                { stat: "fail", error: "Data must be an array: #{data.inspect}" }.to_json
              )
            end

            updated = { stat: "ok", total: 0, updated: 0, monitors: [], errors: [] }
            data.each do |d|
              original = d.dup # UptimeRobot::Client modifies `d`, avoid this for errors
              updated[:total] += 1
              updated[:monitors] << UppityRobot::Client.new(:editMonitor, d).execute
              updated[:updated] += 1
            rescue UptimeRobot::Error => e
              updated[:errors] << "#{e.message} for: #{original.inspect}"
            end

            puts updated.to_json
          rescue CSV::MalformedCSVError, JSON::ParserError => e
            puts JSON.generate({ stat: "fail", error: "Invalid input: #{e.message}" })
          end
          # rubocop:enable Metrics/AbcSize

          def check_format(format)
            return if %w[csv json].include? format

            abort({ stat: "fail",
                    error: "Format not recognized, must be one of: [csv, json]" }.to_json)
          end

          def parse_data(format, data)
            if format == "json" && File.file?(data)
              JSON.parse(File.read(data))
            elsif format == "json"
              JSON.parse(data)
            elsif format == "csv" && File.file?(data)
              rows = []
              CSV.foreach(data, headers: true, header_converters: :symbol) do |row|
                rows << row.to_hash
              end
              rows
            else
              abort({ stat: "fail", error: "Error parsing data: #{format}, #{data.inspect}" }.to_json)
            end
          end
        end
      end
    end
  end
end
