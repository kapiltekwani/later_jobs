class LaterJob < ActiveRecord::Base
  ParseObjectFromYaml = /\!ruby\/\w+\:([^\s]+)/
  enum status: [:inprogress, :picked, :failed, :success]
  scope :jobs_to_run, ->(limit) { where('run_at <= ?', Time.now).where(status: nil).order('run_at ASC').limit(limit) }
  scope :failed_jobs, -> { where(status: LaterJob.status[:failed]) }
  scope :running_jobs, -> { where(status: LaterJob.status[:inprogress]) }
  scope :finished_jobs, -> { where(status: LaterJob.status[:success]) }

  def handler_class
    handler_object.class
  end

  def handler_object
    @handler_object ||= deserialize_handler(self['handler'])
  end


  private

  def attempt_to_load(klass)
    klass.constantize
  end

  #this logic is taken from DelayedJob gem as while deserializing
  # YAML object, the deserialzed object was not getting loaded
  # There was explicit need to reload the deserialized Object's class
  
  def deserialize_handler(serialized_handler)
    @deserialize_handler = YAML.load(serialized_handler) rescue nil

    unless @deserialize_handler.respond_to?(:perform)
      if @deserialize_handler.nil? && serialized_handler =~ ParseObjectFromYaml
        handler_class = $1
      end
      attempt_to_load(handler_class || @deserialize_handler.class)
      @deserialize_handler = YAML.load(serialized_handler)
    end

    return @deserialize_handler if @deserialize_handler.respond_to?(:perform)
  end
end