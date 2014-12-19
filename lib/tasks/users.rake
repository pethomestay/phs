namespace :users do
  namespace :response_rate do
    desc "Update the response rates and store it in the user model"
    task :create => :environment do
      User.all.each(&:response_rate_in_percent)
    end
  end
end
