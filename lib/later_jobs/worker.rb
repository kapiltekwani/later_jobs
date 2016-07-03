module LaterJobs
  class Worker
    #maximum number of jobs to pick per worker
    MAX_JOBS = 3

    def initialize(max_jobs)
      @max_jobs = max_jobs || MAX_JOBS
    end

    def jobs
      @jobs ||= ::LaterJob.jobs_to_run(@max_jobs).to_a
      @jobs.each { |job| job.update_attribute(:status, LaterJob.statuses[:picked]) if db_connected? }
      @jobs
    end

    def call(*args)
      run
    ensure
      #After the worker has finished executing job, worker should return the DB connection back
      ::ActiveRecord::Base.clear_active_connections!
    end

    def has_jobs?
      @jobs = nil if @jobs.blank?
      jobs.any?
    end

    private
    def run
      jobs.each do |job|
        begin
          unless job.inprogress?
            job.update_attribute(:status, LaterJob.statuses[:inprogress])
            job.handler_object.perform
            job.update_attribute(:status, LaterJob.statuses[:success])
            @jobs.delete(job)
          end
        rescue Exception => e
          job.update_attributes({status: :failed, failed_at: Time.now})
          puts e
          return false  # job execution failed so return false
        end
      end if db_connected? #Execute the job only when the worker has active DB connection

      @jobs = nil if @jobs.empty?
    end

    def db_connected?
      #Check if the worker has active DB connection
      ActiveRecord::Base.connection_pool.with_connection { |con| con.active? }  rescue false
    end
  end
end
