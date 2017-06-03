class LocationsController < ApplicationController
  include GeoLocate

  before_action :set_location, :authenticate_user!, only: [:show, :edit, :update, :destroy]

  def index

    # include Geo
    @current_location = location(request.remote_ip)
    if params[:category].nil?
      @locations = Location.all.sort_by &:name
    else
      @locations = Location.where(category: params[:category]).sort_by &:name
    end
  end

  def show
  end

  def new
    @location = Location.new
  end

  def edit
  end

  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email) }
  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:name, :latitude, :longitude, :city, :state, :country, :zip_code, :address, :category)
    end
end
