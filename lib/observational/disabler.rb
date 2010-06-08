require 'observational/observable'

module Observational

  class << self
    def disable
      @disabled = true
    end

    def enable
      @disabled = false
    end

    def disabled?
      @disabled
    end

    def with_observers
      pre_disabled = @disabled
      enable
      yield
      @disabled = pre_disabled
    end
  end

  Observable.class_eval do
    alias old_notify_observers notify_observers
    def notify_observers(*args)
      return if Observational.disabled?
      old_notify_observers(*args)
    end
  end
end
