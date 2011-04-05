require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'active_record'
require 'active_record_env'

describe "Observational::ActiveRecord" do

  before do
    @user = User.new
  end

  ActiveRecord::Callbacks::CALLBACKS.each do |callback|
    describe "observing #{callback}" do
      it "should fire the observer during that callback" do
        pending "fix this if we want AR support out of observational"
        obj = Class.new {
          observes :user, :invokes => :subscription, :on => callback
          def self.subscription(user)
          end
        }
        obj.expects(:subscription).with(@user)
        @user.send :run_callbacks, callback
      end
    end
  end

  describe "adding custom callbacks" do
    before do
      pending "fix this if we want AR support out of observational"
      User.send :define_callbacks, :after_something_else
      self.expects(:subscription).with(@user)
      observes :user, :invokes => :subscription, :after => :something_else
    end

    it "should make it possible to observe those using observational" do
      pending "fix this if we want AR support out of observational"
      @user.send :run_callbacks, :after_something_else
    end
  end
end
