require 'spec_helper'

describe HomestaysController do
  before do
    controller.stub(:authenticate_user!).and_return true
    Homestay.any_instance.stub(:geocode).and_return true
  end

  def valid_attributes(override_or_add={})
    {
      cost_per_night: '0',
      address_1: Faker::Address.street_address,
      address_suburb: 'Bondi',
      address_city: 'Sydney',
      address_country: 'AU',
      title: Faker::Company.name,
      description: Faker::Lorem.paragraph,
      property_type_id: '3',
      outdoor_area_id: '3',
      accept_liability: '1',
      parental_consent: '1',
    }.merge(override_or_add)
  end

  describe 'GET #show' do
    subject { get :show, id: homestay.slug }
    let(:homestay) { FactoryGirl.create :homestay }
    before { controller.stub(:current_user).and_return homestay.user }

    it 'should make homestay to the pets variable' do
      subject
      assigns(:homestay).should == homestay
    end
  end

  describe 'GET #new' do
    subject { get :new }
    before { controller.stub_chain(:current_user, :build_homestay).and_return 'New Homestay' }

    it 'should make a new homestay object available to views' do
      subject
      assigns(:homestay).should == 'New Homestay'
    end

    it 'should render the new template' do
      subject
      response.should render_template :new
    end
  end

  describe 'POST #create' do
    subject { post :create, homestay: attributes }
    let(:user) { FactoryGirl.create :user }
    before do
      controller.stub(:current_user).and_return user
    end
    context 'with valid attributes' do
      let(:attributes) { valid_attributes }
      it 'should create a new homestay for the current user' do
        subject
        user.homestay.should_not be_nil
      end

      it 'should redirect back to the pets list' do
        subject
        response.should redirect_to homestay_path(user.homestay.reload)
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { valid_attributes(address_1: nil) }
      it 'should not add a homestay for the current user' do
        subject
        user.reload.homestay.should be_nil
      end

      it 'should re-render the new template' do
        subject
        response.should render_template :new
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, id: homestay.slug }
    let(:homestay) { FactoryGirl.create :homestay }
    before do
      controller.stub(:current_user).and_return homestay.user
      controller.stub_chain(:current_user, :homestay).and_return homestay
    end
    it 'should make a the homestay object available to views for editing' do
      subject
      assigns(:homestay).should == homestay
    end

    it 'should render the edit template' do
      subject
      response.should render_template :edit
    end
  end

  describe 'PUT #update' do
    subject { put :update, id: homestay.slug, homestay: attributes }
    let(:user) { FactoryGirl.create(:user, homestay: homestay) }
    let(:homestay) { FactoryGirl.create :homestay }
    before do
      controller.stub(:current_user).and_return user
    end

    context 'with valid attributes' do
      let(:attributes) { valid_attributes }
      it 'should update the homestays details' do
        subject
        homestay.reload.description.should == attributes[:description]
      end

      it 'should redirect back to the user account' do
        subject
        response.should redirect_to homestay
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { valid_attributes(address_1: nil) }
      it 'should not update the homestay attributes' do
        subject
        homestay.title.should_not == valid_attributes[:title]
      end

      it 'should re-render the edit template' do
        subject
        response.should render_template :edit
      end
    end
  end

	describe 'GET favourite' do
		subject { get :favourite, id: homestay.id }
		let(:homestay) { FactoryGirl.create :homestay }

		before { controller.stub(:current_user).and_return homestay.user }

		it 'should favourite this homestay' do
			subject
			response.status.should be_eql(200)
		end
	end


	describe 'GET non_favourite' do
		subject { get :non_favourite, id: homestay.id }
		let(:homestay) { FactoryGirl.create :homestay }

		before { controller.stub(:current_user).and_return homestay.user }

		context 'when homestay is not favourite' do
			it 'should sent 302' do
				subject
				response.status.should be_eql(302)
			end
		end

		context 'when homestay is favourite' do
			before { Favourite.create! user_id: homestay.user.id, homestay_id: homestay.id }

			it 'should sent 200 ok message' do
				subject
				response.status.should be_eql(200)
			end
		end
	end

	describe 'GET favourites' do
		subject { get :favourites }
		let(:homestay) { FactoryGirl.create :homestay }

		before { controller.stub(:current_user).and_return homestay.user }
		it 'should render favourites list' do
			subject
			response.should render_template :favourites
		end
	end

  describe "Get availability" do

    let(:user) { FactoryGirl.build(:user) }
    let(:homestay) { FactoryGirl.build(:homestay, id: 1) }
    let(:start_date){ Date.today }
    let(:end_date){ Date.today + 4.days }
    let(:booking_info){ [1,2,3] }

    before do
      Homestay.stub(:find).with("1").and_return(homestay)
      homestay.stub(:user).and_return(user)
      user.stub(:booking_info_between).with(start_date, end_date).and_return(booking_info)
    end

    it "should pass booking info message to current user" do
      user.should_receive(:booking_info_between).with(start_date, end_date)
      get :availability, id: homestay.id, start: start_date.to_time.to_i, end: end_date.to_time.to_i
    end

    it "should return 200 status codes" do
      get :availability, id: homestay.id, start: start_date.to_time.to_i, end: end_date.to_time.to_i
      expect(response.code).to eq("200")
    end

    it "should return booking info json data" do
      get :availability, id: homestay.id, start: start_date.to_time.to_i, end: end_date.to_time.to_i
      expect(response.body).to eq(booking_info.to_json)
    end

  end
end
