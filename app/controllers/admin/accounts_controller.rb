class Admin::AccountsController < Admin::AdminController
	respond_to :html

	def index
		@accounts = Account.all
	end

	def show
		@account = Account.find(params[:id])
	end
end