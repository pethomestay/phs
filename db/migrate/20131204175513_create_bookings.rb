class CreateBookings < ActiveRecord::Migration
	def self.up
		create_table :bookings do |t|
			t.integer :booker_id
			t.integer :bookee_id
			t.text :message
			t.string :pet_name
			t.string :guest_name
			t.references :enquiry
			t.references :homestay
			t.date :check_in_date
			t.time :check_in_time
			t.date :check_out_date
			t.time :check_out_time
			t.integer :number_of_nights, default: 1
			t.integer :cost_per_night, default: 1
			t.integer :subtotal, default: 1
			t.integer :amount, default: 1
			t.boolean :host_accepted, default: false
			t.boolean :owner_accepted, default: false
			t.string :status, default: BOOKING_STATUS_UNFINISHED

			t.timestamps
		end
	end

	def self.down
		drop_table :bookings
	end
end
