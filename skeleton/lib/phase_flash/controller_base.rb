require_relative '../phase6/controller_base'
require_relative 'session'

module PhaseFlash
  class ControllerBase < Phase6::ControllerBase
    def flash
      session.flash
    end
  end
end