require 'WEBrick'
require 'phase_csrf/controller_base'

describe PhaseCSRF::ControllerBase do
  before(:all) do
    class CatsController < PhaseCSRF::ControllerBase
    end
  end
  after(:all) { Object.send(:remove_const, "CatsController") }
  
  let(:session) { double("session") }
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  
  before(:each) do
    allow_any_instance_of(CatsController).to receive(:session)
      .and_return(session)
  end
  
  context "when generating auth tokens" do
    let(:controller) { CatsController.new(req, res) }
    before(:each) do
      allow(req).to receive(:request_method).and_return("GET")
    end
    
    it "stores the token in the session" do
      expect(session).to receive(:[]=).with("authenticity_token", be_a(String))
      controller.form_authenticity_token
    end
    
    it "generates a unique token each time" do
      token1 = {}
      token2 = {}
      allow(controller).to receive(:session).and_return(token1, token2)
      
      2.times { controller.form_authenticity_token }
      expect(token1).not_to eq(token2)
    end
    
    it "returns the token" do
      allow(session).to receive(:[]=)
      expect(controller.form_authenticity_token).to be_a(String)
    end
    
  end
  
  context "when authenticating"
  
    context "for get request" do
    
      it "doesn't try to authenticate" do
        allow(req).to receive(:request_method).and_return("GET")
        expect_any_instance_of(CatsController).not_to receive(:authenticate)
        CatsController.new(req, res)
      end
    end
  
    context "for non-get request" do
      let(:params) { double("params") }
      before(:each) do
        allow(req).to receive(:request_method).and_return("POST")
        allow_any_instance_of(CatsController).to receive(:params)
          .and_return(params)
      end
    
      it "tries to authenticate" do
        expect_any_instance_of(CatsController).to receive(:authenticate)
        CatsController.new(req, res)
      end
      
      it "allows requests to proceed if auth token matches" do
        allow(session).to receive(:[]=)
        
        allow(params).to receive(:[]).with("authenticity_token")
          .and_return("sweettokenbro")
        allow(session).to receive(:[]).with("authenticity_token")
          .and_return("sweettokenbro")
          
        expect { CatsController.new(req, res) }.not_to raise_error
      end
      
      it "raises error if auth token doesn't match" do
        allow(params).to receive(:[]).with("authenticity_token")
          .and_return("sweettokenbro")
        allow(session).to receive(:[]).with("authenticity_token")
          .and_return("TERRIBLE TOKEN DUDE!")
        
        error = "Invalid authenticity token!"
        expect { CatsController.new(req, res) }.to raise_error(error)
      end
      
      it "raises error if session and param tokens are both nil" do
        allow(params).to receive(:[]).with("authenticity_token")
          .and_return(nil)
        allow(session).to receive(:[]).with("authenticity_token")
          .and_return(nil)
          
        error = "Missing authenticity token!"
        expect { CatsController.new(req, res) }.to raise_error(error)
      end
      
      it "removes auth token after authentication" do
        allow(params).to receive(:[]).with("authenticity_token")
          .and_return("sweettokenbro")
        allow(session).to receive(:[]).with("authenticity_token")
          .and_return("sweettokenbro")
          
        expect(session).to receive(:[]=).with("authenticity_token", nil)
        CatsController.new(req, res)
      end
    end
end