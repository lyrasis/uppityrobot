# frozen_string_literal: true

RSpec.describe Uppityrobot::Client do
  let(:api_key) { "api_key" }
  let(:task) { :getMonitors }
  let(:fake_task) { :getRabbits }
  let(:params) { {} }

  before(:each) do
    ENV["UPTIMEROBOT_API_KEY"] = api_key
  end

  it "can instantiate a client when UPTIMEROBOT_API_KEY is defined" do
    expect { Uppityrobot::Client.new(task, params) }.to_not raise_error
  end

  it "cannot instantiate a client when UPTIMEROBOT_API_KEY is undefined" do
    ENV["UPTIMEROBOT_API_KEY"] = nil
    expect { Uppityrobot::Client.new(task, params) }.to raise_error(SystemExit, /UPTIMEROBOT_API_KEY/)
  end

  it "cannot instantiate a client when the task is not recognized" do
    expect { Uppityrobot::Client.new(fake_task, params) }.to raise_error(SystemExit, /Task not recognized/)
  end
end
