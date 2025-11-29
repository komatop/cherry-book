class TextFormatter
  def format(report)
    <<~FORMAT
      === Report: #{report.date} ===
      
      #{report.tasks.map {|task| "- #{task}"}.join("\n")}
    FORMAT
  end
end
