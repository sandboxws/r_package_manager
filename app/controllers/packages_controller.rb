class PackagesController < ApplicationController
  def show
  end

  def search
    @q = params[:q]
    @packages = Package.where(title: /#{@q}/).order(downloads: :desc).page(params[:page]).per(5)
  end
end
