module Observational
  module MongoMapperObservers
    CALLBACKS = [
      :before_save,                 :after_save,
      :before_create,               :after_create,
      :before_update,               :after_update,
      :before_validation,           :after_validation,
      :before_validation_on_create, :after_validation_on_create,
      :before_validation_on_update, :after_validation_on_update,
      :before_destroy,              :after_destroy,
      :validate_on_create,          :validate_on_update,
      :validate]

    def self.included(klass)
      CALLBACKS.each do |callback|
        klass.send(callback) { |obj| obj.send :notify_observers, callback }
      end
      klass.class_eval do
        extend ClassMethods
        class << self
          alias_method_chain :define_callbacks, :observational
        end
      end
    end

    module ClassMethods
      def define_callbacks_with_observational(*callbacks)
        define_callbacks_without_observational *callbacks
        callbacks.each do |c|
          send(c) { |obj| obj.send :notify_observers, c }
        end
      end
    end
  end
end

