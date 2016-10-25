# A wrapper for the GET /events API
#
module ThisData
  class Event

    # Fetch an array of Events from the ThisData API
    # Available options can be found at
    #   http://help.thisdata.com/docs/v1getevents
    #
    # Returns: Array of OpenStruct Event objects
    def self.all(options={})
      response = ThisData::Client.new.get('/events', query: options)
      # Use NestedStruct to turn this Array of deep Hashes into an array of
      # OpenStructs
      response.parsed_response["results"].collect do |event_hash|
        NestedStruct.new(event_hash)
      end
    end

  end
end