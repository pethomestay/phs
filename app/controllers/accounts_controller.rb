class AccountsController < ApplicationController
	before_filter :authenticate_user!

	def new
		@account = Account.new
	end

	def create
		@account = Account.new(params[:account])
		if @account.save
			return redirect_to @account
		else
			render 'new'
		end
	end

	def edit
		@account = current_user.account
	end

	def update
		@account = current_user.account
		if @account.update_attributes(params[:account])
			puts
			puts
			puts @account.errors.inspect
			puts
			puts
			return redirect_to @account
		else
			render :edit
		end
	end

	def show
		@account = current_user.account
	end
end