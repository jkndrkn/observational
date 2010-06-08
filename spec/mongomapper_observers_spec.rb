require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'mongo_mapper'
require 'observational/mongo_mapper_observers'

MongoMapper.connection = Mongo::Connection.new('127.0.0.1')
MongoMapper.database = 'observable_test'

class Widget
  include MongoMapper::Document
  include Observational::MongoMapperObservers
  key :name, String
end

describe "Observational::MongoMapperObservers" do
  include Observational

  before do
    @widget = Widget.new
  end

  Observational::MongoMapperObservers::CALLBACKS.each do |callback|
    describe "observing #{callback}" do
      it "should fire the observer during that callback" do
        self.expects(:foo).with(@widget)
        observes :widget, :invokes => :foo, :on => callback
        @widget.send :run_callbacks, callback
      end
    end
  end

  describe "custom callbacks" do
    it "trigger the observers" do
      Widget.send :define_callbacks, :after_something_else
      observes :widget, :invokes => :bar, :after => :something_else
      self.expects(:bar).with(@widget)
      @widget.send :run_callbacks, :after_something_else
    end
  end
end
