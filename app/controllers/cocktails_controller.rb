require 'open-uri'
require 'json'

class CocktailsController < ApplicationController
  def index
    @cocktails = Cocktail.all
  end

  def show
    @cocktail = Cocktail.find(params[:id])
  end

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    url = "https://api.unsplash.com/search/photos?query=#{@cocktail.name}+cocktail&orientation=landscape&client_id=5fe258ea2bd9e5e5444ddbbc3a8bb538be5d7b41a518e87cf394221cd9b236ba"
    doc = open(url).read
    json = JSON.parse(doc)
    if @cocktail.save
      img_url = json["results"][0]["urls"]["raw"].split("?")[0]
      @cocktail.img_url = img_url
      @cocktail.save
      redirect_to new_cocktail_dose_path(@cocktail)
    else
      render "new"
    end
  end

  private

  def cocktail_params
    params.require(:cocktail).permit(:name)
  end
end
