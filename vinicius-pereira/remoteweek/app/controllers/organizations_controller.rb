class OrganizationsController < ApplicationController
  def index
    @organizations = Organization.all.order(:name)
  end

  def show
    @organization = Organization.find(params[:id])
    @users = @organization.users.order(:name)
  end
end
