require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe "#current_admin_user" do
    let(:user) { create :user }

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    context "user is admin" do
      before do
        allow(controller.current_user).to receive(:admin?).and_return(true)
      end

      it { expect(controller.current_admin_user).to eq user }
    end

    context "user is not admin" do
      before do
        allow(controller.current_user).to receive(:admin?).and_return(false)
      end

      it { expect(controller.current_admin_user).to be_nil }
    end
  end

  describe "#user_action" do
    subject { controller.send :user_action }

    context "controller is pages" do
      before { controller.params[:controller] = "pages" }

      context "action is home" do
        before { controller.params[:action] = "home" }

        it { is_expected.to eq "Went to homepage" }
      end

      context "untrackable action" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Untracked behaviour in pages" }
      end
    end

    context "controller is homestays" do
      before { controller.params[:controller] = "homestays" }

      context "action is index" do
        before { controller.params[:action] = "index" }

        it { is_expected.to eq "Searched for Homestay" }
      end

      context "action is favourite" do
        before { controller.params[:action] = "favourite" }

        it { is_expected.to eq "Clicked on Favourite for Homestay" }
      end

      context "action is non_favourite" do
        before { controller.params[:action] = "non_favourite" }

        it { is_expected.to eq "Un-favourited homestay" }
      end

      context "action is new" do
        before { controller.params[:action] = "new" }

        it { is_expected.to eq "Creating new homestay" }
      end

      context "action is edit" do
        before { controller.params[:action] = "edit" }

        it { is_expected.to eq "Changed homestay" }
      end

      context "action is activate" do
        before { controller.params[:action] = "activate" }

        it { is_expected.to eq "Toggle activated for homestay" }
      end

      context "untrackable action" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Untracked behaviour in homestays" }
      end
    end

    context "controller is registrations" do
      before { controller.params[:controller] = "registrations" }

      context "action is new" do
        before { controller.params[:action] = "new" }

        it { is_expected.to eq "Signing up" }
      end

      context "action is cancel" do
        before { controller.params[:action] = "cancel" }

        it { is_expected.to eq "Cancel Signing up" }
      end

      context "action is edit" do
        before { controller.params[:action] = "edit" }

        it { is_expected.to eq "User account edit" }
      end

      context "action is destroy" do
        before { controller.params[:action] = "destroy" }

        it { is_expected.to eq "User deleting their account" }
      end

      context "untrackable action" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Untracked behaviour in registrations" }
      end
    end

    context "controller is users/omniauth_callbacks" do
      before { controller.params[:controller] = "users/omniauth_callbacks" }

      it { is_expected.to eq "Sign in/Sign up via Facebook" }
    end

    context "controller is devise/confirmations" do
      before { controller.params[:controller] = "devise/confirmations" }

      it { is_expected.to eq "Confirmed account" }
    end

    context "controller is feedbacks" do
      before { controller.params[:controller] = "feedbacks" }

      it { is_expected.to eq "Leaving feedback" }
    end

    context "controller is users" do
      before { controller.params[:controller] = "users" }

      context "action is set_coupon" do
        before { controller.params[:action] = "set_coupon" }

        it { is_expected.to eq "Applied a coupon code" }
      end

      context "action is decline_coupon" do
        before { controller.params[:action] = "decline_coupon" }

        it { is_expected.to eq "Declined to use a coupon code" }
      end

      context "action is show" do
        before do
          controller.params[:action] = "show"
          controller.params[:id] = "test"
        end

        it { is_expected.to eq "Looked at user: test" }
      end

      context "action is edit" do
        before { controller.params[:action] = "edit" }

        it { is_expected.to eq "Edit user details" }
      end

      context "action is destroy" do
        before { controller.params[:action] = "destroy" }

        it { is_expected.to eq "User deleting their account" }
      end

      context "untrackable action" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Untracked behaviour in users" }
      end
    end

    context "controller is enquiries" do
      before { controller.params[:controller] = "enquiries" }

      it { is_expected.to eq "New enquiry made" }
    end

    context "controller is unavailable_dates" do
      before { controller.params[:controller] = "unavailable_dates" }

      context "action is create" do
        before { controller.params[:action] = "create" }

        it { is_expected.to eq "Made date unavailable" }
      end

      context "untrackabale action" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Made date available" }
      end
    end

    context "controller is guest/pets" do
      before { controller.params[:controller] = "guest/pets" }

      context "action is new" do
        before { controller.params[:action] = "new" }

        it { is_expected.to eq "Creating a new pet" }
      end

      context "action is edit" do
        before { controller.params[:action] = "edit" }

        it { is_expected.to eq "Editing a pet" }
      end

      context "action is destroy" do
        before { controller.params[:action] = "destroy" }

        it { is_expected.to eq "Deleting a pet" }
      end

      context "action is create" do
        before { controller.params[:action] = "create" }

        it { is_expected.to eq "Finished creating a new pet" }
      end

      context "action is update" do
        before { controller.params[:action] = "update" }

        it { is_expected.to eq "Finished editing pet" }
      end

      context "action is index" do
        before { controller.params[:action] = "index" }

        it { is_expected.to eq "Went to list of pets" }
      end

      context "untrackable action" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Untracked behaviour in pets screen" }
      end
    end

    context "controller is guest/messages" do
      before { controller.params[:controller] = "guest/messages" }

      context "action is create" do
        before { controller.params[:action] = "create" }

        it { is_expected.to eq "Sending new message" }
      end

      context "action is mark_read" do
        before { controller.params[:action] = "mark_read" }

        it { is_expected.to eq "Read a message" }
      end

      context "untrackable action" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Guest messages screen" }
      end
    end

    context "controller is host/host" do
      before { controller.params[:controller] = "host/host" }

      context "action is index" do
        before { controller.params[:action] = "index" }

        it { is_expected.to eq "Host dashboard screen" }
      end

      context "untrackable action" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Untracked behaviour in host/host" }
      end
    end

    context "controller is host/homestays" do
      before { controller.params[:controller] = "host/homestays" }

      context "action is new" do
        before { controller.params[:action] = "new" }

        it { is_expected.to eq "Creating a homestay" }
      end

      context "action is create" do
        before { controller.params[:action] = "create" }

        it { is_expected.to eq "Created a homestay" }
      end

      context "action is edit" do
        before { controller.params[:action] = "edit" }

        it { is_expected.to eq "Editing a homestay" }
      end

      context "action is update" do
        before { controller.params[:action] = "update" }

        it { is_expected.to eq "Edited a homestay" }
      end

      context "untrackable action" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Untracked behaviour in host/homestays" }
      end
    end

    context "controller is host/bookings" do
      before { controller.params[:controller] = "host/bookings" }

      it { is_expected.to eq "List of Host bookings page" }
    end

    context "controller is unlink" do
      before { controller.params[:controller] = "unlink" }

      it { is_expected.to eq "Unlinked Facebook" }
    end

    context "controller is guest/accounts" do
      before { controller.params[:controller] = "guest/accounts" }

      context "action is new" do
        before { controller.params[:action] = "new" }

        it { is_expected.to eq "Account details screen" }
      end

      context "action is edit" do
        before { controller.params[:action] = "edit" }

        it { is_expected.to eq "Account details screen" }
      end

      context "action is show" do
        before { controller.params[:action] = "show" }

        it { is_expected.to eq "Account details screen" }
      end

      context "action is create" do
        before { controller.params[:action] = "create" }

        it { is_expected.to eq "Changed bank account details" }
      end

      context "action is update" do
        before { controller.params[:action] = "update" }

        it { is_expected.to eq "Changed bank account details" }
      end

      context "action is untrackable" do
        before { controller.params[:action] = "untrackable action here" }

        # @FIXME
        it { is_expected.to eq "Untracked behaviour in host/accounts" }
      end
    end

    context "controller is host/accounts" do
      before { controller.params[:controller] = "host/accounts" }

      context "action is new" do
        before { controller.params[:action] = "new" }

        it { is_expected.to eq "Account details screen" }
      end

      context "action is edit" do
        before { controller.params[:action] = "edit" }

        it { is_expected.to eq "Account details screen" }
      end

      context "action is show" do
        before { controller.params[:action] = "show" }

        it { is_expected.to eq "Account details screen" }
      end

      context "action is create" do
        before { controller.params[:action] = "create" }

        it { is_expected.to eq "Changed bank account details" }
      end

      context "action is update" do
        before { controller.params[:action] = "update" }

        it { is_expected.to eq "Changed bank account details" }
      end

      context "action is untrackable" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Untracked behaviour in host/accounts" }
      end
    end

    context "controller is guest/guest" do
      before { controller.params[:controller] = "guest/guest" }

      it { is_expected.to eq "Guest dashboard screen" }
    end

    context "controller is guest/favorites" do
      before { controller.params[:controller] = "guest/favorites" }

      it { is_expected.to eq "Guest favourites screen" }
    end

    context "controller is bookings" do
      before { controller.params[:controller] = "bookings" }

      context "action is edit" do
        before { controller.params[:action] = "edit" }

        it { is_expected.to eq "Host or Guest reviewing enquiry" }
      end

      context "action is host_receipt" do
        before { controller.params[:action] = "host_receipt" }

        it { is_expected.to eq "Host viewing receipt for booking" }
      end

      context "action is host_confirm" do
        before { controller.params[:action] = "host_confirm" }

        it { is_expected.to eq "Host reviewing paid booking" }
      end

      context "action is show" do
        before { controller.params[:action] = "show" }

        it { is_expected.to eq "Host viewing booking details" }
      end

      context "untrackable action" do
        before { controller.params[:action] = "untrackable action here" }

        it { is_expected.to eq "Untracked event in bookings" }
      end
    end

    context "controller is host/messages" do
      before { controller.params[:controller] = "host/messages" }

      it { is_expected.to eq "Host messages screen" }
    end

    context "untrackable controller" do
      it { is_expected.to eq "Untracked behaviour" }
    end
  end

end
