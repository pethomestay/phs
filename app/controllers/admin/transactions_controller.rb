class Admin::TransactionsController < Admin::AdminController
	respond_to :html

	def index
		respond_with(:admin, @transactions = Transaction.order('created_at DESC'))
	end

	def show
		respond_with(:admin, @transaction = Transaction.find(params[:id]))
	end

end
