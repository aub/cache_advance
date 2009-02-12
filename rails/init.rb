require 'cache_advance'
require 'cache_advance/active_record_sweeper'

require "#{RAILS_ROOT}/config/caches"
require 'dispatcher'

# Setup the sweeper and cache types as appropriate for Rails.
CacheAdvance.cache_set.sweeper_type = CacheAdvance::ActiveRecordSweeper

CacheAdvance.caching_enabled = config.action_controller.perform_caching

class ActionController::Base
  include CacheAdvance::ActionControllerMixin
end

class ActionMailer::Base
  include CacheAdvance::ActionMailerMixin
end

# This will get called after the standard rails environment is initialized.
config.after_initialize do
  if config.action_controller.perform_caching
    # This hooks the sweepers into the observer system and adds it to the list.
    CacheAdvance.cache_set.create_sweepers
    ActiveRecord::Base.observers << CacheAdvance::ActiveRecordSweeper

    # In development mode, the models we observe get reloaded with each request. Using
    # this hook allows us to reload the observer relationships each time as well.
    ActionController::Dispatcher.to_prepare(:cache_advance_reload) do
      CacheAdvance::ActiveRecordSweeper.instance.reload_sweeper
    end
  end
end
