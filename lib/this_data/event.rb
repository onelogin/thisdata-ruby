# A wrapper for the GET /events API
#
#
module ThisData
  class Event

    # Fetch an array of Events from the ThisData API
    # Available options can be found at
    #   http://help.thisdata.com/docs/v1getevents
    #
    # Returns: Array of Hashes
    def self.all(options={})
      response = ThisData::Client.new.get('/events', query: options)
      response.parsed_response["results"]
    end

  end
end