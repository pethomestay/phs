namespace :pets do
  namespace :personalities do
    desc 'Strip the empty element in personalities'
    task :strip => :environment do
      Pet.where('personalities IS NOT NULL').each do |pet|
          pet.personalities.delete('')
          pet.save
      end

      puts 'Finished!'
    end
  end
end
