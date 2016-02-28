class Admin::HomestaysController < Admin::AdminController
  respond_to :html

  def index
    respond_with(:admin, (@homestays, @alphaParams = Homestay.includes(:user).alpha_paginate(params[:letter], js: false){ |homestay| homestay.user.last_name }))
  end

  def by_date_created
    respond_with(:admin, @homestays = Homestay.order('created_at DESC').includes(:user).paginate(page: params[:page], per_page: 100))
  end

  def show
    respond_with(:admin, @homestay = Homestay.find_by_slug!(params[:id]))
  end

  def edit
    respond_with(:admin, @homestay = Homestay.find_by_slug!(params[:id]))
  end

  def update
    @homestay = Homestay.find_by_slug!(params[:id])
    @homestay.update_attributes(params[:homestay])
    flash[:errors] = @homestay.errors.full_messages if @homestay.errors.any?
    respond_with(:admin, @homestay)
  end

  def locking
    @homestay = Homestay.find_by_slug!(params[:homestay_id])
    if @homestay.locked
      #need to send out message to user to let them know it's approved!
      #### DELETE THIS ONCE YOU START USING INTERCOM
      HomestayApprovedJob.new.async.perform(@homestay)
    end
    @homestay.locked = !@homestay.locked #toggle locked state
    @homestay.active = !@homestay.locked #active is going to be the reverse of locked ie locked true then active false

    @homestay.save
    respond_to do | format|
      format.js
    end
  end

  def destroy
    @homestay = Homestay.find_by_slug!(params[:id])
    @homestay.destroy

    respond_with(:admin, @homestay)
  end
end
