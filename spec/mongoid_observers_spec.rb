require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'mongoid'
require 'observational/mongoid_observers'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new('127.0.0.1').db('observable_test')
end

class Thingamajig
  include Mongoid::Document
  include Observational::MongoidObservers
  include Observational::Observable
  key :name, String
end

describe "Observational::MongoidObservers" do
  include Observational

  before do
    @thingamajig = Thingamajig.new
  end

  Observational::MongoidObservers::CALLBACKS.each do |callback|
    describe "observing ##{callback}" do
      Observational::MongoidObservers::PREFIXES.each do |prefix|
        prefixed_callback = "#{prefix}_#{callback}".to_sym
          it "fires the '#{prefix}' observer during that callback" do
            observer = Class.new {
              observes :thingamajig, :invokes => :foo, prefix.to_sym => callback
              def self.foo(thingamajig)
              end
            }
            observer.expects(:foo).with(@thingamajig)
            @thingamajig.send :run_callbacks, callback
          end
        end
      end
  end

  describe "custom callbacks" do
    it "trigger the observers" do
      pending "until we actually need this..."
      Thingamajig.send :define_callbacks, :something_else
      observer = Class.new {
          observes :thingamajig, :invokes => :bar, :after => :something_else
          def self.bar(thingamajig)
          end
        }
      observer.expects(:bar).with(@thingamajig)
      @thingamajig.send :run_callbacks, :something_else
    end
  end
end
