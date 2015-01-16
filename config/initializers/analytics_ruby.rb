segment_write_key = Rails.env != "production" ? "LzIUcFHSww9aWbFUuKkHChCzf43BeM8x" : "LxxkTXLXYph1SjMTSjyDOItgUh55ElPi"

Analytics = Segment::Analytics.new({
    write_key: segment_write_key,
    on_error: Proc.new { |status, msg| print msg }
})