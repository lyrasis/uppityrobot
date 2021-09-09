# frozen_string_literal: true

module UppityRobot
  module CLI
    module Commands
      module Monitors
        # # UppityRobot::CLI::Commands::Monitors::List lists monitors
        class List < Dry::CLI::Command
          desc "List Monitors"

          option :csv, type: :string, desc: "Path to additionally save results as csv"
          option :filter, type: :string, default: '{"friendly_name": ".*"}', desc: "Filter string for monitors"
          option :search, type: :string, desc: "keyword within url or friendly_name"

          example [
            "--search aspace",
            '--filter \'{"friendly_name": "^aspace-"}\'',
            '--search aspace --filter \'{"status": 0}\''
          ]

          def call(csv: nil, filter: '{"friendly_name": ".*"}', search: nil, **)
            filter   = JSON.parse(filter)
            filtered = { stat: "ok", total: 0, monitors: [] }
            params   = search ? { search: search } : {}

            UppityRobot::Client.new(:getMonitors, params).filter(filter).each do |m|
              filtered[:monitors] << m
            end

            filtered[:total] = filtered[:monitors].count
            write_csv(csv, filtered[:monitors])
            puts filtered.to_json
          rescue JSON::ParserError => e
            puts JSON.generate({ stat: "fail", error: "JSON parser #{e.message}" })
          end

          def write_csv(file, data)
            return unless file

            CSV.open(File.expand_path(file), "wb", encoding: "UTF-8") do |csv|
              csv << data.first.keys
              data.each { |hash| csv << hash.values }
            end
          end
        end
      end
    end
  end
end
