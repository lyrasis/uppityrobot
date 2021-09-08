# frozen_string_literal: true

RSpec.describe UppityRobot do
  it "has a version number" do
    expect(UppityRobot::VERSION).not_to be nil
  end

  it "has a root directory" do
    root = UppityRobot::ROOT
    expect(File.directory?(root)).to be_truthy
  end
end
