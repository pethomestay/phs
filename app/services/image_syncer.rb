class ImageSyncer
  PERMITTED_RESOURCE_TYPES = ['Booking', 'Homestay', 'Pet', 'User']

  attr_reader :image_params, :resource_params, :image, :resource, :errors

  # Init.
  # @api public
  # @param image_params [Hash] Passed params that identify the image.
  # @param resource_params [Hash] Passed params that identify the resource.
  # @return [ImageUploader]
  def initialize(image_params, resource_params)
    @image_params = image_params.to_options
    @resource_params = resource_params.to_options
    @errors = []
  end

  # Syncs the remote image with the local resource.
  # If the image already exists locally, no syncing is performed.
  # @api public
  # @return [Attachinary::File] The newly-synced image.
  # @return [nil] If the sync was unsuccessful.
  def sync
    if identify_resource
      if existing_image.present?
        existing_image
      else
        identify_image
        sync_image
      end
    end
  end

  private

  # Looks for a matching local resource.
  # @api private
  # @return [ActiveRecord::Base] The resource.
  # @return [nil] If no matching resource can be found.
  def identify_resource
    resource_type = resource_params[:type].camelize
    unless PERMITTED_RESOURCE_TYPES.include?(resource_type)
      errors << "Unrecognised resource type: #{resource_type}"
      return nil
    end

    @resource = begin
      resource_type.constantize.find(resource_params[:id])
    rescue ActiveRecord::RecordNotFound
      errors << "Unrecognised resource ID: #{resource_params[:id]}"
      nil
    end
  end

  # Queries Cloudinary for details of the image.
  # @api private
  # @return [Hashie::Mash] The Cloudinary image.
  # @return [nil] If no matching image can be found.
  def identify_image
    result = Hashie::Mash.new(Cloudinary::Api.resources_by_ids([image_params[:id]]))
    if result.resources.empty?
      errors << "Unrecognised image ID: #{image_params[:id]}"
      return nil
    end

    @image = Hashie::Mash.new(result.resources.first)
  end

  # Looks for an pre-existing local image.
  # @api private
  # @return [ActiveRecord::Base] The existing image.
  # @return [nil] If no matching image can be found.
  def existing_image
    if resource.present?
      @existing_image ||= Attachinary::File.where(
        public_id: image_params[:id],
        attachinariable_id: resource.id,
        attachinariable_type: resource.class.name,
        scope: attachinary_scope
      ).first
    end
  end

  # Maps the passed scope to a Cloudinary one.
  # @api private
  # @return [String] The Attachinary scope.
  def attachinary_scope
    mappings = {
      booking: {gallery: 'photos'},
      homestay: {gallery: 'photos'},
      pet: {avatar: 'profile_photo', gallery: 'extra_photos'},
      user: {gallery: 'profile_photo'}
    }
    mappings[resource_params[:type].to_sym][image_params[:scope].to_sym]
  end

  # Syncs a Cloudinary image to a local resource.
  # @note Includes nasty hack to suspend Attachinary::File callback.
  # @api private
  # @return [ActiveRecord::Base] The newly synced image.
  # @return [nil] If the sync failed.
  def sync_image
    if image.present? && resource.present?
      Attachinary::File.skip_callback(:create, :after, :remove_temporary_tag)
      file = Attachinary::File.new(
        public_id: image.public_id,
        version: image.version,
        width: image.width,
        height: image.height,
        format: image.format,
        resource_type: image.resource_type
      )
      file.attachinariable = resource
      file.scope = attachinary_scope
      file.save
      Attachinary::File.set_callback(:create, :after, :remove_temporary_tag)
      file
    end
  end
end
