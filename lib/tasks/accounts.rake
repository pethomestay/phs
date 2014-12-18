namespace :accounts do
  desc 'Encrypt (i.e. update) every bank account'
  task :encrypt => :environment do
    puts 'About to update every account in database..'

    Account.all.each do |account|
      account.update_attribute :bsb,            account[:bsb]
      account.update_attribute :name,           account[:name]
      account.update_attribute :account_number, account[:account_number]
    end

    puts 'Finished!'
  end
end
