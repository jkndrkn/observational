require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'observational/disabler'

describe Observable do
  before do
    @klass = Class.new do
      include Observational::Observable

      def save
        fire_observers :after_create
      end
    end
    @observer = Observational::Observer.new :method     => :do_stuff,
                                            :subscriber => stub(:do_stuff => ""),
                                            :actions    => :some_action
      @observable = @klass.new
      @klass.add_observer @observer
  end

  describe "when Observational is disabled" do
    before { Observational.disable }
    after  { Observational.enable }

    it "the observers are not notified of the subscribed actions" do
      @observer.expects(:invoke).never
      @observable.send :notify_observers, :some_action
    end

    it "can be turned back on temporarily with Observational::with_observers" do
      @observer.expects(:invoke).once
      Observational.with_observers do
        @observable.send :notify_observers, :some_action
      end
    end
  end

end
