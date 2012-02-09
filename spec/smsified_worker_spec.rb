# Copyright 2011© MaestroDev.  All rights reserved.

require 'spec_helper'

describe MaestroDev::SmsifiedWorker do

  describe 'send_sms()' do
    before(:all) do
      @test_participant = MaestroDev::SmsifiedWorker.new
    end

    it 'should send a message' do
      wi = Ruote::Workitem.new({"fields" => {"body" => "testing",
                                             "to" => "15551212",
                                             "username" => "bob",
                                             "password" => "joe",
                                             "number" => "15551212"}})
      @test_participant.stubs(:workitem =>wi)
      @test_participant.stubs(:reply_to_engine)

      @test_participant.send_sms
      wi.fields['__error__'].should eql('')
    end

    it 'should error with no body' do
      wi = Ruote::Workitem.new({"fields" => {"to" => "15551212",
                                             "username" => "bob",
                                             "password" => "joe",
                                             "number" => "15551212"}})
      
      @test_participant.stubs(:workitem =>wi)
      @test_participant.stubs(:reply_to_engine)
      @test_participant.stubs(:send_sms => true)

      @test_participant.send_sms
      wi.fields['__error__'].should eql('Invalid body')
    end

    it 'should error with no to' do
      wi = Ruote::Workitem.new({"fields" => {"body" => "testing",
                                             "username" => "bob",
                                             "password" => "joe",
                                             "number" => "15551212"}})
      
      @test_participant.stubs(:workitem =>wi)
      @test_participant.stubs(:reply_to_engine)
      @test_participant.stubs(:send_sms => true)

      @test_participant.send_sms
      wi.fields['__error__'].should eql('Invalid to')
    end

    it 'should fail to send a message, too many chars' do
      body = 'testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123testing123'
      wi = Ruote::Workitem.new({"fields" => {"body" => body,
                                             "to" => "15551212",
                                             "username" => "bob",
                                             "password" => "joe",
                                             "number" => "15551212"}})
      
      @test_participant.stubs(:workitem =>wi)
      @test_participant.stubs(:reply_to_engine)
      @test_participant.stubs(:send_sms => true)

      @test_participant.send_sms
      wi.fields['__error__'].should eql('Invalid body, over 140 chars')
    end

    it 'should error with incorrect credentials' do
      wi = Ruote::Workitem.new({"fields" => {"body" => "testing",
                                             "to" => "15551212",
                                             "username" => "bob",
                                             "password" => "joe",
                                             "number" => "15551212"}})
      
      @test_participant.stubs(:workitem =>wi)
      @test_participant.stubs(:reply_to_engine)

      @test_participant.stubs(:send_sms).raises("Invalid credentials for sending SMS, check configuration.")
      @test_participant.send_sms
      wi.fields['__error__'].should eql("Invalid credentials for sending SMS, check configuration.")
    end

    it 'should error with incorrect from number' do
      wi = Ruote::Workitem.new({"fields" => {"body" => "testing",
                                             "to" => "15551212",
                                             "username" => "bob",
                                             "password" => "joe",
                                             "number" => "15551212"}})
      
      @test_participant.stubs(:workitem =>wi)
      @test_participant.stubs(:reply_to_engine)

      @test_participant.stubs(:send_sms).raises("Invalid (from) number for credentials used, check configuration.")
      @test_participant.send_sms
      wi.fields['__error__'].should eql("Invalid (from) number for credentials used, check configuration.")
    end
  end
end
