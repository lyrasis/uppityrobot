# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

namespace :uppityrobot do
  namespace :tasks do
    def alert_contacts
      ENV.fetch("UPTIMEROBOT_ALERT_CONTACTS") do
        contacts = UppityRobot::Client.new(:getAlertContacts, {}).execute
        contact = contacts["alert_contacts"].find { |c| c["friendly_name"] == friendly_name }
        raise "CONTACT NOT FOUND" unless contact

        contact["id"]
      end
    end

    def friendly_name
      ENV.fetch("UPTIMEROBOT_FRIENDLY_NAME", "")
    end

    def monitors(prefix:)
      monitors = {}
      UppityRobot::Client.new(:getMonitors, search: prefix).filter("friendly_name" => "^#{prefix}").each do |m|
        monitors[m["friendly_name"]] = m
      end
      monitors
    end

    desc "Display uptimerobot contacts set via environment"
    task :contacts do
      raise "UPTIMEROBOT_API_KEY is required" unless ENV["UPTIMEROBOT_API_KEY"]

      puts alert_contacts
    end

    desc "List all uptimerobot monitors by prefix"
    task :list, [:prefix] do |_, args|
      raise "UPTIMEROBOT_API_KEY is required" unless ENV["UPTIMEROBOT_API_KEY"]

      puts monitors(prefix: args.fetch(:prefix)).to_json
    end

    desc "Process uptimerobot monitors csv"
    task :process, [:prefix, :csv] do |_, args|
      raise "UPTIMEROBOT_API_KEY is required" unless ENV["UPTIMEROBOT_API_KEY"]

      prefix = args[:prefix]
      csv = args.fetch(:csv, File.join(Dir.getwd, "files", "monitors", "uptimerobot.csv"))
      raise "CSV not found" unless File.file? csv

      contacts = alert_contacts
      current_monitors = monitors(prefix: prefix)

      CSV.read(csv, headers: true).each do |row|
        data = row.to_hash
        name = data["friendly_name"]
        url = data["url"]

        begin
          if !current_monitors.key?(name)
            puts "Creating monitor: #{name} #{url}"
            d = {
              friendly_name: name,
              url: url,
              interval: interval,
              type: UptimeRobot::Monitor::Type::HTTP,
              subtype: UptimeRobot::Monitor::SubType::HTTPS,
              alert_contacts: contacts
            }
            UppityRobot::Client.new(:newMonitor, d).execute
          elsif current_monitors.key?(name) &&
              (current_monitors[name]["url"] != url || current_monitors[name]["interval"] != interval)
            puts "Updating monitor: #{current_monitors[name]["url"]} TO #{url} [#{interval}] WITH CONTACTS #{contacts}"
            # avoid uptimerobot client weirdness
            d = {id: current_monitors[name]["id"], url: url, alert_contacts: contacts}.dup
            UppityRobot::Client.new(:editMonitor, d).execute
          end
        rescue UptimeRobot::Error => e
          puts "Error processing monitor: #{data} #{e.message}"
        end
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
