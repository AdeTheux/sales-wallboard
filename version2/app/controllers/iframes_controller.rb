class IframesController < ApplicationController
  before_action :set_iframe, only: [:show, :edit, :update, :destroy]

  # GET /iframes
  # GET /iframes.json
  def index
    @iframes = Iframe.all
  end

  # GET /iframes/1
  # GET /iframes/1.json
  def show
  end

  # GET /iframes/new
  def new
    @iframe = Iframe.new
  end

  # GET /iframes/1/edit
  def edit
  end

  # POST /iframes
  # POST /iframes.json
  def create
    @iframe = Iframe.new(iframe_params)

    respond_to do |format|
      if @iframe.save
        format.html { redirect_to @iframe, notice: 'Iframe was successfully created.' }
        format.json { render :show, status: :created, location: @iframe }
      else
        format.html { render :new }
        format.json { render json: @iframe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /iframes/1
  # PATCH/PUT /iframes/1.json
  def update
    respond_to do |format|
      if @iframe.update(iframe_params)
        format.html { redirect_to @iframe, notice: 'Iframe was successfully updated.' }
        format.json { render :show, status: :ok, location: @iframe }
      else
        format.html { render :edit }
        format.json { render json: @iframe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /iframes/1
  # DELETE /iframes/1.json
  def destroy
    @iframe.destroy
    respond_to do |format|
      format.html { redirect_to iframes_url, notice: 'Iframe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iframe
      @iframe = Iframe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def iframe_params
      params.require(:iframe).permit(:title, :url, :department)
    end
end
