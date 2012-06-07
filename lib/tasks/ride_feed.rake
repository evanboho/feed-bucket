desc "Get rides from CL RSS"
task :get_rides => :environment do
    Ride.parse_from_all_cities_from_feed
    Ride.ensure_need_or_want
    Ride.scrape_emails
end

desc "Just get the emails from CL"
task :scrape_emails => :environment do
  Ride.scrape_emails
end

desc "Delete rides w/o need or want"
task :ensure_need_or_want => :environment do
  Ride.ensure_need_or_want
end

desc "Destroy all caps"
task :destroy_all_caps => :environment do
  Ride.destroy_all_caps
end