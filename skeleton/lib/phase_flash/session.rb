require_relative '../phase4/session'

module PhaseFlash
  class Session < Phase4::Session
    attr_reader :flash
    
    def initialize(req)
      cookie = req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }
      @session = cookie ? JSON.parse(cookie.value) : {}
      @flash = Flash.new(self, cookie)
    end
  end
end