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
  
  def enqueue_cpucrasherjobs2
    jobs_count = params[:jobs].to_i
    jobs_count.times{ CpucrasherJob2.perform_later }
    res = {
      "server_response": "added #{jobs_count} CpucrasherJob2 jobs"
    }
    render :plain => res.to_json, status:200, content_type: "application/json"
  end

  def chart

    total=params[:size].to_i
    total_arm=0
    total_x86=0

queue = Sidekiq::Queue.new("default")
queue.each do |job|
    total_arm=total_arm+1;
end
queue = Sidekiq::Queue.new("default2")
queue.each do |job|
    total_x86=total_x86+1;
end
total_arm = total - total_arm
total_x86 = total - total_x86
total = total_arm + total_x86
total_percentage = 100 * total_arm / total_x86
total_percentage = total_percentage - 100
total_percentage=total_percentage.round

    html = '
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script type="text/javascript">
window.onload = function() {

var options = {
        title: {
                text: "ARM / x86 ('+"#{total_percentage}"+'% Faster)"
        },
        data: [{
                        type: "pie",
                        startAngle: 45,
                        showInLegend: "true",
                        legendText: "{label}",
                        indexLabel: "{label} ({y})",
                        yValueFormatString:"#,##0.#"%"",
                        dataPoints: [
                                { label: "ARM", y: '+"#{total_arm}"+' },
                                { label: "x86", y: '+"#{total_x86}"+' },
                                { label: "Total", y: '+"#{total}"+' }
                        ]
        }]
};
$("#chartContainer").CanvasJSChart(options);

}
</script>
</head>
<body>
<div id="chartContainer" style="height: 370px; width: 100%;"></div>
<script type="text/javascript" src="https://canvasjs.com/assets/script/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="https://canvasjs.com/assets/script/jquery.canvasjs.min.js"></script>
<script>
setTimeout(function(){
   window.location.reload();
}, 5000);
</script>
</body>
</html>
    '
    render :plain => html, status:200, content_type: "text/html"
  end
end
