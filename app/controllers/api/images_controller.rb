class Api::ImagesController < Api::BaseController

  # Syncs a remote image to a local resource.
  # @url /images
  # @action POST
  def create
    @syncer = ImageSyncer.new(params[:image], params[:resource])
    @image = @syncer.sync
    render_400 @syncer.errors if @image.blank?
  end

end
