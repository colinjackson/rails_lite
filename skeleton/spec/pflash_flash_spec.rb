require 'webrick'
require 'json'
require 'phase_flash/flash'
require 'phase_flash/session'
require 'phase_flash/controller_base'

describe PhaseFlash::Flash do
  let!(:session) { double("session") }
  let!(:flash_values) { Hash.new }

  let!(:cookie) { WEBrick::Cookie.new('', { flash: flash_values }.to_json) }
  subject(:flash) { PhaseFlash::Flash.new(session, cookie) }

  before(:each) do
    allow(session).to receive(:[]=).with(:flash, {})
  end

  it "sets the session's flash value to an empty hash" do
    expect(session).to receive(:[]=).with(:flash, {})
    PhaseFlash::Flash.new(session)
  end

  context "with no flash data" do
    it "stores an empty hash" do
      expect(flash.keys).to be_empty
      expect(flash.values).to be_empty
    end
  end

  context "with flash data" do
    let(:flash_values) { { errors: ["Too flashy!"] } }

    it "gets the current flash value from the cookie" do
      allow(session).to receive(:[]).with(:flash).and_return("hello")
      expect(flash[:errors]).to eq(["Too flashy!"])
    end

    it "sets the next flash value in the session" do
      next_flash = double("next_flash")
      expect(next_flash).to receive(:[]=).with(:errors, ['ay, carumba!'])
      expect(session).to receive(:[]).with(:flash).and_return(next_flash)

      flash[:errors] = ['ay, carumba!']
    end

    it "can change the current flash value through flash.now" do
      flash.now[:new_key] = :new_value
      expect(flash[:new_key]).to be(:new_value)
    end
  end
end

describe PhaseFlash::Session do
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:flash_values) { {flash: {errors: ["Too fanciful"]}} }
  let(:cookie) { WEBrick::Cookie.new('_rails_lite_app', flash_values.to_json) }
  
  it "generates a flash instance on initialize" do
    req.cookies << cookie
    session = PhaseFlash::Session.new(req)
    expect(session.flash).to be_a(PhaseFlash::Flash)
  end
end
