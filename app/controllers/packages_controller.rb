class PackagesController < ApplicationController
  def show
    @package = Package.find params[:slug]
    @versions = @package.versions.order(created_at: :desc)
  end

  def search
    @q = params[:q]
    @packages = Package.where(title: /#{@q}/).order(downloads: :desc).page(params[:page]).per(5)
  end
end
