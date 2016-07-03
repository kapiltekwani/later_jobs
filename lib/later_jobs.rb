autoload :ActiveRecord, 'active_record'

require 'later_jobs/engine'
require 'later_jobs/job'
require 'later_jobs/worker'
require 'eventmachine'
require 'thread'

module LaterJobs
  class Runner
    MAX_WORKERS = 3

    # max_workers = 2
    # max_jobs_per_worker = 1

    def initialize(max_workers, max_jobs_per_worker)
      @max_workers = max_workers || MAX_WORKERS
      @max_jobs_per_worker = max_jobs_per_worker
    end

    # execute each worker and its job when job persists
    # execution will happen on a periodical check on 2 seconds

    # runner = LaterJobs::Runner.new(max_workers, max_jobs_per_worker)
    # runner.execute
    def execute
      EM.run do
        @workers = []
        @max_workers.times { @workers << Worker.new(@max_jobs_per_worker) }

        EM.add_periodic_timer(2) do
          @workers.each { |worker| EM.defer( worker ) if worker.has_jobs? }
        end
      end
    end

  end
end
