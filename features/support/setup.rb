# frozen_string_literal: true

require "aruba/cucumber"
require "json_spec/cucumber"
require "sinatra/base"
require "capybara_discoball"
require "uppityrobot"

module FakeUptimeRobot
  # FakeUptimeRobot app
  class Application < Sinatra::Base
    def fixture_file_json(file)
      JSON.parse(
        File.read(
          File.join(UppityRobot::ROOT, "fixtures", file)
        )
      ).to_json
    end

    def search_fixture(term)
      case term
      when "Google"
        "getMonitors.google.json"
      when "My Web Page"
        "getMonitors.mywebpage.json"
      else
        "getMonitors.json"
      end
    end

    post "/v2/editMonitor" do
      content_type :json
      fixture_file_json "editMonitor.json"
    end

    post "/v2/getAlertContacts" do
      content_type :json
      fixture_file_json "getAlertContacts.json"
    end

    post "/v2/getMonitors" do
      content_type :json
      fixture_file_json search_fixture(params[:search])
    end

    post "/v2/newMonitor" do
      content_type :json
      fixture_file_json "newMonitor.json"
    end
  end
end

endpoint = nil
FakeUptimeRobotRunner =
  Capybara::Discoball::Runner.new(FakeUptimeRobot::Application) do |server|
    endpoint = "http://#{server.host}:#{server.port}"
  end

FakeUptimeRobotRunner.boot

def last_json
  last_command_started.output
end

Before do |_scenario|
  ENV["UPTIMEROBOT_API_KEY"] = "api_key"
  ENV["UPTIMEROBOT_ENDPOINT"] = endpoint
end
