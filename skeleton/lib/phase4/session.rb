require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }
      @session = cookie ? JSON.parse(cookie.value) : {}
    end

    def [](key)
      @session[key.to_s]
    end

    def []=(key, val)
      @session[key.to_s] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      session_json = @session.to_json
      cookie = WEBrick::Cookie.new('_rails_lite_app', session_json)
      res.cookies << cookie
    end
  end
end
