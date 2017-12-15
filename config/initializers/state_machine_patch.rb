# Patch added after upgrading to Rails 4.1

module StateMachine::Integrations::ActiveModel
  public :around_validation
end
