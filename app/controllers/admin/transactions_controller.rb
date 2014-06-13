class Admin::TransactionsController < Admin::AdminController
	respond_to :html

	def index
		respond_with(:admin, @transactions = Transaction.order('created_at DESC'))
	end

	def show
		respond_with(:admin, @transaction = Transaction.find(params[:id]))
  end

  def edit
    @transaction = Transaction.find(params[:id])
    respond_with(:admin, @transaction)
  end

  def update
    @transaction = Transaction.find(params[:id])
    @transaction.update_attributes(params[:transaction])
    if not params[:transaction][:pre_authorisation_id].blank?
      @transaction.booking.payment_check_succeed
      @transaction.booking.save!
    end
    respond_with(:admin, @transaction)
  end

end
