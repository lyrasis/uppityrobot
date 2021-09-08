# frozen_string_literal: true

RSpec.describe UppityRobot::Client do
  let(:api_key) { "api_key" }
  let(:task) { :getMonitors }
  let(:fake_task) { :getRabbits }
  let(:params) { {} }

  before(:each) do
    ENV["UPTIMEROBOT_API_KEY"] = api_key
    allow_any_instance_of(UppityRobot::Client).to receive(:execute).and_return(
      JSON.parse(File.read(File.join(UppityRobot::ROOT, "fixtures", "getMonitors.json")))
    )
  end

  it "can instantiate a client when UPTIMEROBOT_API_KEY is defined" do
    expect { UppityRobot::Client.new(task, params) }.to_not raise_error
  end

  it "cannot instantiate a client when UPTIMEROBOT_API_KEY is undefined" do
    ENV["UPTIMEROBOT_API_KEY"] = nil
    expect { UppityRobot::Client.new(task, params) }.to raise_error(SystemExit, /UPTIMEROBOT_API_KEY/)
  end

  it "cannot instantiate a client when the task is not recognized" do
    expect { UppityRobot::Client.new(fake_task, params) }.to raise_error(SystemExit, /Task not recognized/)
  end

  it "can get records" do
    client = UppityRobot::Client.new(task, params)
    expect(client.execute["stat"]).to eq "ok"
  end

  it "can filter records" do
    client = UppityRobot::Client.new(task, params)
    expect(client.filter({}).count).to eq 2
    expect(client.filter({ "friendly_name" => "Google" }).count).to eq 1
  end

  it "can paginate records" do
    client = UppityRobot::Client.new(task, params)
    monitors = []
    client.paginate.each { |r, _o, _t| monitors += r["monitors"] }
    expect(monitors.count).to eq 2
  end
end
