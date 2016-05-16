module ThisData
  class Score

    RISK_LEVEL_GREEN  = "green"
    RISK_LEVEL_ORANGE = "orange"
    RISK_LEVEL_RED    = "red"

    # A float from 0 - 1 which represents the risk of the event.
    # 0: low risk, 1: high risk
    attr_accessor :score

    # A string representation of the score, bucketed in to
    #  "green", "orange", "red" based on the perceived risk by ThisData
    attr_accessor :risk_level

    # An Array of Strings with messages about what signals were triggered in
    # generating this score
    # Default: []
    attr_accessor :triggers

    def initialize(**attributes)

      self.triggers = []

      attributes.each_pair do |name, object|
        send("#{name}=", object)
      end
    end

    # Creates a Score object using the HTTP response from ThisData's verify API.
    def self.initialize_from_response(response)
      json = response.parsed_response
      self.new(
        score:      json["score"],
        risk_level: json["risk_level"],
        triggers:   json["triggers"],
      )
    end

  end
end