# frozen_string_literal: true

module UppityRobot
  # UppityRobot::Client is a CLI focused wrapper for the UptimeRobot::Client
  class Client
    attr_reader :response

    RECORD_TYPES = {
      getAlertContacts: "alert_contacts",
      getMonitors: "monitors"
    }.freeze

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
      type = RECORD_TYPES[@task]
      Enumerator.new do |yielder|
        paginate.each do |response, _offset, _total|
          response[type].find_all do |record|
            satisfies_conditions = true
            filter.each do |key, regex|
              satisfies_conditions = false unless record.key?(key) && record[key].to_s =~ /#{regex}/
            end
            yielder << record if satisfies_conditions
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

    # use when a single record result is expected & required
    def fetch
      verify_fetch_params
      # TODO: support alert_contacts search (requires filter)
      response = execute
      verify_fetch_total response
      response[RECORD_TYPES[@task]].first
    end

    private

    def client
      options = { api_key: ENV.fetch("UPTIMEROBOT_API_KEY") }
      options[:url] = ENV["UPTIMEROBOT_ENDPOINT"] if ENV["UPTIMEROBOT_ENDPOINT"]
      UptimeRobot::Client.new(options)
    rescue KeyError => e
      abort({ stat: "fail", error: "Error, #{e.message}" }.to_json)
    end

    def parse_total(response)
      response.key?("total") ? response["total"] : response["pagination"]["total"]
    end

    def verify_fetch_params
      return if @params.key?(:search) || @params.key?(RECORD_TYPES[@task].to_sym)

      abort(
        { stat: "fail", error: "Attempted fetch without required params" }.to_json
      )
    end

    def verify_fetch_total(response)
      total = parse_total response
      return if total == 1

      abort(
        {
          stat: "fail",
          error: "Did not receive exactly one result: #{response.inspect}"
        }.to_json
      )
    end

    def verify_task(task)
      unless UptimeRobot::Client::METHODS.include? task
        error = {
          stat: "fail",
          error: "Task not recognized [#{task}], must be: #{UptimeRobot::Client::METHODS.join(", ")}"
        }.to_json
        abort(error)
      end
      task
    end
  end
end
