require_relative '../phase6/controller_base'

module PhaseCSRF
  class ControllerBase < Phase6::ControllerBase
    def initialize(req, res, route_params = {})
      authenticate unless req.request_method.downcase.to_sym == :get
      super
    end
    
    def form_authenticity_token
      session["authenticity_token"] = SecureRandom.base64(16)
    end
    
    private
    def authenticate
      if params["authenticity_token"] != session["authenticity_token"]
        raise "Invalid authenticity token!"
      elsif !(params["authenticity_token"] && session["authenticity_token"])
        raise "Missing authenticity token!"
      end
      
      session["authenticity_token"] = nil
    end
  end
end