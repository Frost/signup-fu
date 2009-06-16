module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      root_path
      
    when /the events page/
      events_path
      
    when /the reply page for "([^\"]*)"/
      event = Event.find_by_name($1)
      new_event_event_reply_path(event)
    
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end
end

World(NavigationHelpers)

