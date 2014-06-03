class Ckeditor::Asset < ActiveRecord::Base
  extend Dragonfly::Model
  include Ckeditor::Orm::ActiveRecord::AssetBase
  include Ckeditor::Backend::Dragonfly

  dragonfly_accessor :data, :app => :ckeditor
  validates_presence_of :data
end
