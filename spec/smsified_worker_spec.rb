# Copyright 2011© MaestroDev.  All rights reserved.

require 'spec_helper'
require 'smsified'

describe MaestroDev::SmsifiedWorker do

  describe 'send_sms()' do
    before(:each) do
      @testee = MaestroDev::SmsifiedWorker.new
    end

    after(:each) do
      workitem = nil
    end

    it 'should error with no body' do
      workitem = {'fields' => {"to" => "testing",
                               "username" => "bob",
                               "password" => "joe",
                               "number" => "15551212"}}
      @testee.stub(:workitem).and_return(workitem)
  
  
   
      @testee.send_sms
      workitem['fields']['__error__'].should include('Missing Field body')
    end

    it 'should error with no to' do
      workitem = {"fields" => {"body" => "testing",
                               "username" => "bob",
                               "password" => "joe",
                               "number" => "15551212"}}
      @testee.stub(:workitem).and_return(workitem)

      @testee.send_sms
      workitem['fields']['__error__'].should include('Missing Field to')
    end

    it 'should fail to send a message, too many chars' do
      body = 'testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123'
      workitem = {"fields" => {"body" => body,
                               "to" => "15551212",
                               "username" => "bob",
                               "password" => "joe",
                               "number" => "15551212"}}
      @testee.stub(:workitem).and_return(workitem)

      @testee.send_sms
      workitem['fields']['__error__'].should eql('Invalid body, over 140 chars')
    end

    it 'should error with incorrect credentials' do
      workitem = {"fields" => {"body" => "testing",
                               "to" => "15551212",
                               "username" => "bob",
                               "password" => "joe",
                               "number" => "15551212"}}
      @testee.stub(:workitem).and_return(workitem)

      oneapi = double("oneapi")
      Smsified::OneAPI.stub(:new).and_return(oneapi)

      response = Object.new
      response.stub(:data).and_return("kit")
      response.stub(:http).and_return(Net::HTTPUnauthorized.new("4.0.1","401","Failed"))
      oneapi.should_receive(:send_sms).and_return(response)

      @testee.send_sms
      workitem['fields']['__error__'].should eql("Invalid credentials for sending SMS, check configuration.")
    end

    it 'should error with incorrect from number' do
      workitem = {"fields" => {"body" => "testing",
                               "to" => "15551212",
                               "username" => "bob",
                               "password" => "joe",
                               "number" => "15551212"}}
      @testee.stub(:workitem).and_return(workitem)

      # https://github.com/smsified/smsified-ruby/blob/master/lib/smsified/response.rb
      #Smsified::Response.stub_chain(:http,:is_a?).and_return(Net::HTTPBadRequest)
      oneapi = double("oneapi")
      Smsified::OneAPI.stub(:new).and_return(oneapi)

      response = Object.new
      response.stub(:data).and_return("kit")
      response.stub(:http).and_return(Net::HTTPBadRequest.new("4.0.1","400","Failed"))
      oneapi.should_receive(:send_sms).and_return(response)
      @testee.send_sms
      workitem['fields']['__error__'].should eql("Invalid (from) number for credentials used, check configuration.")
    end

    it 'should send a message' do
      workitem = {"fields" => {"body" => "testing",
                               "to" => "15551212",
                               "username" => "bob",
                               "password" => "joe",
                               "number" => "15551212"}}
      @testee.stub(:workitem).and_return(workitem)
      oneapi = double("oneapi")
      Smsified::OneAPI.stub(:new).and_return(oneapi)

      response = Object.new

      response.stub(:data).and_return("kit")
      response.stub(:http).and_return(Net::HTTPCreated.new("4.0.1","200","Success"))
      oneapi.should_receive(:send_sms).and_return(response)
      @testee.send_sms
      workitem['fields']['__error__'].should eql('')
    end
  end
end
