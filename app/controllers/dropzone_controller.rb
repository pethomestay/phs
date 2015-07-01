class DropzoneController < ApplicationController
  before_filter :authenticate_user!

  def photo_uploads
    uploaded = false
    if params[:photo]
      upload_response = Cloudinary::Uploader.upload(File.open(params[:photo].path))
      json_response = upload_response.to_json
      uploaded = true
      if !params[:attachinariable_type].blank? and !params[:attachinariable_id].blank? and !params[:attachinary_scope].blank?
        attachinariable_class = params[:attachinariable_type].to_s.camelize.safe_constantize
        attachinariable       = (attachinariable_class ? attachinariable_class.find_by_id(params[:attachinariable_id]) : nil)
        if attachinariable
          if upload_response and upload_response["public_id"]
            attachment = case params[:attachinary_scope]
            when "photos"
              attachinariable.photos.new
            when "profile_photo"
              unless attachinariable.profile_photo.blank?
                attachinariable.profile_photo.destroy
                attachinariable.reload
              end
              attachinariable.profile_photo.new
            when "extra_photos"
              attachinariable.extra_photos.new
            else
              nil
            end
            if attachment
              attachment.public_id      = upload_response["public_id"]
              attachment.version        = upload_response["version"]
              attachment.width          = upload_response["width"] 
              attachment.height         = upload_response["height"] 
              attachment.format         = upload_response["format"] 
              attachment.resource_type  = upload_response["resource_type"]
              attachment.save
            end
          end
        end
      end
    end
    if uploaded
      render :json => json_response, :status => :created
    else
      render :json => "Error", :status => :unprocessable_entity
    end
  end

  def remove_uploads
    response_json = { "status" => "error" }
    if !params[:id].blank? and !params[:model_type].blank? and !params[:model_id].blank? and !params[:scope].blank?
      attachinariable_class = params[:model_type].to_s.camelize.safe_constantize
      attachinariable       = (attachinariable_class ? attachinariable_class.find_by_id(params[:model_id]) : nil)
      if attachinariable
        attachment = case params[:scope]
          when "photos"
            attachinariable.photos.where("id = ?", params[:id]).first
          when "profile_photo"
             if attachinariable.profile_photo and attachinariable.profile_photo.id == params[:id].to_i
                attachinariable.profile_photo
              else
                nil
              end
          when "extra_photos"
            attachinariable.extra_photos.where("id = ?", params[:id]).first
          else
            nil
          end
        if attachment
          attachment.destroy
          response_json["status"] = "success"
        end
      end
    end
    render :json => response_json.to_json
  end

  def remove_uploads_with_public_id
    if params[:public_id]
      attachment = Attachinary::File.where("public_id = ?", params[:public_id]).first
      if attachment
        attachment.destroy
      else
        Cloudinary::Uploader.destroy(params[:public_id])
      end
    end
    render :json => "ok"
  end
end