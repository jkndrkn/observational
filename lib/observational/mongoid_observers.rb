module Observational
  module MongoidObservers
    CALLBACKS = [:create, :destroy, :initialize, :save, :update, :validation]
    PREFIXES = %w[before after]
    CALLBACKS_OMITTED = [:before_initialize]

    def self.included(klass)
      CALLBACKS.each do |callback|
        PREFIXES.each do |prefix|
          prefixed_callback = "#{prefix}_#{callback}".to_sym
          next if CALLBACKS_OMITTED.include? prefixed_callback

          klass.send(prefixed_callback) { |obj| obj.send :notify_observers, prefixed_callback }
        end
      end
      #klass.class_eval do
      #  extend ClassMethods
      #  class << self
      #    alias_method_chain :define_callbacks, :observational
      #  end
      #end
    end

    #module ClassMethods
    #  def define_callbacks_with_observational(*callbacks)
    #    define_callbacks_without_observational *callbacks
    #    callbacks.each do |callback|
    #      PREFIXES.each do |prefix|
    #        prefixed_callback = "#{prefix}_#{callback}".to_sym
    #        send(prefixed_callback) { |obj| obj.send :notify_observers, prefixed_callback }
    #      end
    #    end
    #  end
    #end
  end
end
