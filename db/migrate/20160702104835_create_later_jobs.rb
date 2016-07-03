class CreateLaterJobs < ActiveRecord::Migration
  def change
    create_table :later_jobs do |t|
      t.integer  :attempts, :default => 0
      t.text     :handler
      t.text     :last_error
      t.datetime :run_at
      t.datetime :failed_at
      t.string   :status

      t.timestamps null: false
    end
  end
end
