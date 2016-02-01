class HomepageController < ApplicationController
  def index
    @packages = Package.all.limit(10)
  end
end
