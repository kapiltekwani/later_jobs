module LaterJobs
  class Job
    def self.enqueue(object, args = {})
      unless object.respond_to?(:perform) || block_given?
         raise ArgumentError, 'Cannot enqueue objects which do not respond to perform'
       end

      ::LaterJob.create(handler: object.to_yaml , run_at: (args[:run_at] || Time.now))

    end
  end
end