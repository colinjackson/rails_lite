require_relative 'session'

module PhaseFlash
  class Flash
    
    def initialize(session, cookie = nil)
      @now_flash = cookie ? JSON.parse(cookie.value)["flash"] : {}
      @session = session
      @session[:flash] = {}
    end
    
    def [](key)
      @now_flash[key.to_sym] || @now_flash[key.to_s]
    end
    
    def []=(key, value)
      @session[:flash][key] = value
    end
    
    def now
      @now_flash
    end
    
    def keys
      @now_flash.keys
    end
    
    def values
      @now_flash.values
    end
    
  end
end