namespace :pets do
  namespace :personalities do
    desc 'Strip the empty element in personalities'
    task :strip => :environment do
      Pet.all.each do |pet|
        pet.personalities.delete('') if pet.personalities.present?
        pet.save
      end

      puts 'Finished!'
    end
  end
end
