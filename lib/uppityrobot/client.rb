# frozen_string_literal: true

module Uppityrobot
  # Uppityrobot::Client is a CLI focused wrapper for the UptimeRobot::Client
  class Client
    attr_reader :response

    def initialize(task, params)
      @client   = client
      @task     = verify_task(task)
      @params   = params
      @response = nil
    end

    def execute
      @response = client.send(@task, @params)
    end

    def filter(filter = {})
      Enumerator.new do |yielder|
        paginate.each do |response, _offset, _total|
          response["monitors"].find_all do |monitor|
            satisfies_conditions = true
            filter.each do |key, regex|
              satisfies_conditions = false unless monitor.key?(key) && monitor[key].to_s =~ /#{regex}/
            end
            yielder << monitor if satisfies_conditions
          end
        end
      end.lazy
    end

    def paginate
      Enumerator.new do |yielder|
        @params.delete :offset # we want to start from the beginning
        response = execute # initial connection
        offset   = 0
        limit    = response["pagination"]["limit"]
        total    = response["pagination"]["total"]

        loop do
          raise StopIteration if offset >= total

          @params  = @params.merge({ offset: offset })
          response = execute
          yielder << [response, offset, total]
          offset += limit
        end
      end.lazy
    end

    private

    def client
      UptimeRobot::Client.new(api_key: ENV.fetch("UPTIMEROBOT_API_KEY"))
    rescue KeyError => e
      abort({ "stat": "fail", "error": "Error, #{e.message}" }.to_json)
    end

    def verify_task(task)
      unless UptimeRobot::Client::METHODS.include? task
        error = {
          "stat": "fail",
          "error": "Task not recognized [#{task}], must be: #{UptimeRobot::Client::METHODS.join(", ")}"
        }.to_json
        abort(error)
      end
      task
    end
  end
end
