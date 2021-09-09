# frozen_string_literal: true

require "aruba/cucumber"

Before do |_scenario|
  ENV["UPTIMEROBOT_API_KEY"] = "api_key"
end
