module Forge
  class Error < StandardError
  end

  # Raised when the link source could not be found
  class LinkSourceNotFound < Error
  end
end
