Given /^that now is "([^\"]*)"$/ do |time|
  year, month, day = time.split("-")
  Time.stub!(:now).and_return(Time.local(year, month, day, 12, 0))
end

Given /^that now is (\d+) (\w+) (.+)$/ do |count, unit, tense|
  time = count.send(unit).send(tense.gsub(" ", "_"))
  Time.stub!(:now).and_return(time)
end

