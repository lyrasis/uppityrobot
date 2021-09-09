# frozen_string_literal: true

require "aruba/cucumber"
require "sinatra/base"
require "capybara_discoball"
require "uppityrobot"

module FakeUptimeRobot
  # FakeUptimeRobot app
  class Application < Sinatra::Base
    post "/v2/getMonitors" do
      content_type :json
      JSON.parse(File.read(File.join(UppityRobot::ROOT, "fixtures", "getMonitors.json"))).to_json
    end
  end
end

endpoint = nil
FakeUptimeRobotRunner =
  Capybara::Discoball::Runner.new(FakeUptimeRobot::Application) do |server|
    endpoint = "http://#{server.host}:#{server.port}"
  end

FakeUptimeRobotRunner.boot

Before do |_scenario|
  ENV["UPTIMEROBOT_API_KEY"] = "api_key"
  ENV["UPTIMEROBOT_ENDPOINT"] = endpoint
end
