require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'mongoid'
require 'observational/mongoid_observers'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new('127.0.0.1').db('observable_test')
end

class Thingamajig
  include Mongoid::Document
  include Observational::MongoidObservers
  key :name, String
end

describe "Observational::MongoidObservers" do
  include Observational

  before do
    @thingamajig = Thingamajig.new
  end

  Observational::MongoidObservers::CALLBACKS.each do |callback|
    describe "observing #{callback}" do
      it "should fire the observer during that callback" do
        self.expects(:foo).with(@thingamajig)
        observes :thingamajig, :invokes => :foo, :on => callback
        @thingamajig.send :run_callbacks, callback
      end
    end
  end

  describe "custom callbacks" do
    it "trigger the observers" do
      Thingamajig.send :define_callbacks, :after_something_else
      observes :thingamajig, :invokes => :bar, :after => :something_else
      self.expects(:bar).with(@thingamajig)
      @thingamajig.send :run_callbacks, :after_something_else
    end
  end
end
