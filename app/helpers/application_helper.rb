module ApplicationHelper
  def valid_url?(url)
    open(url)
  rescue
    false
  end
end
