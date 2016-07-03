namespace :later_jobs do
  desc "Start the LaterJobs Server"

  #rake later_jobs:start_server  NUMBER_OF_WORKERS=3 NUMBER_OF_JOBS_PER_WORKER=2
  #This command with start the later_jobs server with 3 worker processes each worker executing 2 jobs

  #rake later_jobs:start_server
  #This command with start the later_jobs server with default 2 worker processes each worker executing 1 job by default


  task :start_server => :environment do
      number_of_workers = ENV['NUMBER_OF_WORKERS'].nil? ? 2 : ENV['NUMBER_OF_WORKERS'].to_i
      number_of_jobs_per_worker = ENV['NUMBER_OF_JOBS_PER_WORKER'].nil? ? 1 : ENV['NUMBER_OF_JOBS_PER_WORKER'].to_i
      runner = runner = LaterJobs::Runner.new(number_of_workers, number_of_jobs_per_worker)
      runner.execute
   end
end
