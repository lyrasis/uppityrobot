# frozen_string_literal: true

module UppityRobot
  module CLI
    module Commands
      module Monitors
        # UppityRobot::CLI::Commands::Monitors::Create creates an HTTP monitor
        class Create < Dry::CLI::Command
          desc "Create a new HTTP monitor"

          argument :name, required: true, desc: "The name for the monitor"
          argument :url, required: true, desc: "The http/s url to monitor"
          argument :contacts, required: true, desc: "The list of contact ids"

          example [
            "google https://www.google.com 1-2-3"
          ]

          def call(name:, url:, contacts:, **)
            sub_type = check_subtype(URI.parse(url))

            data = {
              friendly_name: name,
              url: url,
              type: UptimeRobot::Monitor::Type::HTTP,
              sub_type: sub_type,
              alert_contacts: contacts
            }

            response = UppityRobot::Client.new(:newMonitor, data).execute
            puts response.to_json
          rescue URI::InvalidURIError => e
            puts JSON.generate({stat: "fail", error: "URI parser #{e.message}"})
          end

          def check_subtype(uri)
            if uri.instance_of?(URI::HTTP)
              UptimeRobot::Monitor::SubType::HTTP
            elsif uri.instance_of?(URI::HTTPS)
              UptimeRobot::Monitor::SubType::HTTPS
            else
              abort({stat: "fail",
                     error: "Monitor URL must be HTTP/S"}.to_json)
            end
          end
        end
      end
    end
  end
end
