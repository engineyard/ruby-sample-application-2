class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def enqueue_jobs
    jobs_count = params[:jobs].to_i
    jobs_count.times{ EchoJob.perform_later }
    res = {
      "server_response": "added #{jobs_count} EchoJob jobs"
    }
    render :plain => res.to_json, status:200, content_type: "application/json"
  end

  def enqueue_cpucrasherjobs
    jobs_count = params[:jobs].to_i
    jobs_count.times{ CpucrasherJob.perform_later }
    res = {
      "server_response": "added #{jobs_count} CpucrasherJob jobs"
    }
    render :plain => res.to_json, status:200, content_type: "application/json"
  end
  
end
