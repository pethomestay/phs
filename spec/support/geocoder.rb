Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.add_stub(
  '2041, Australia', [
    {
      'latitude'     => -33.8546842,
      'longitude'    => 151.1840188,
      'address'      => 'Sydney NSW 2041, Australia',
      'state'        => 'New South Wales',
      'state_code'   => 'NSW',
      'country'      => 'Australia',
      'country_code' => 'AU'
    }
  ]
)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => -37.8152065,
      'longitude'    => 144.963937,
      'address'      => 'Melbourne VIC 3000, Australia',
      'state'        => 'Victoria',
      'state_code'   => 'VIC',
      'country'      => 'Australia',
      'country_code' => 'AU'
    }
  ]
)
