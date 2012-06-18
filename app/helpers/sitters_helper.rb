module SittersHelper
  def my_sitter?(sitter)
    current_user && sitter == current_user.sitter
  end
end
