class QuartersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :ensure_admin!

  # GET /quarters
  # GET /quarters.json
  def index
    @quarters = Quarter.order("begin_date DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quarters }
    end
  end

  # GET /quarters/1
  # GET /quarters/1.json
  def show
    @quarter = Quarter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quarter }
    end
  end

  # GET /quarters/new
  # GET /quarters/new.json
  def new
    @users = User.all
    @quarter = Quarter.new
    @quarter.current = true

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quarter }
    end
  end

  # GET /quarters/1/edit
  def edit
    @users = User.all
    @quarter = Quarter.find(params[:id])
  end

  # POST /quarters
  # POST /quarters.json
  def create
    if params[:date_quarter].nil?
      @quarter.errors.add "You need to select a quarter"
    end
    if params[:year].nil?
      @quarter.errors.add "You need to select a year"
    end

    @quarter = Quarter.new(params[:quarter])

    if params[:year] && params[:date_quarter]
      @quarter.set_from_quarter_number!(params[:date_quarter].to_i, params[:year].to_i)
    end

    saved = @quarter.save
    if saved
      params[:users_ids].each do |user_id|
        target = params[:users_targets][user_id]
        @quarter.assignations.create(user_id: user_id,
                                     month_target_1: target["0"],
                                     month_target_2: target["1"],
                                     month_target_3: target["2"])
      end
    end


    respond_to do |format|
      if saved
        format.html { redirect_to @quarter, notice: 'Quarter was successfully created.' }
        format.json { render json: @quarter, status: :created, location: @quarter }
      else
        format.html { render action: "new" }
        format.json { render json: @quarter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quarters/1
  # PUT /quarters/1.json
  def update
    if params[:date_quarter].nil?
      @quarter.errors.add "You need to select a quarter"
    end
    if params[:year].nil?
      @quarter.errors.add "You need to select a year"
    end

    @quarter = Quarter.find(params[:id])

    if params[:year] && params[:date_quarter]
      @quarter.set_from_quarter_number!(params[:date_quarter].to_i, params[:year].to_i)
      params[:quarter][:begin_date] = @quarter.begin_date
      params[:quarter][:end_date] = @quarter.end_date
    end

    updated = @quarter.update_attributes(params[:quarter])

    if updated
      users_ids = (params[:users_ids] or []).map { |x| x.to_i }
      if not users_ids.blank?
        to_delete = @quarter.assignations.where(["id NOT IN (?)", users_ids])
      else
        to_delete = @quarter.assignations.all
      end
      to_delete.each {|assign| assign.delete}
      users_ids.each do |user_id|
        user = User.find(user_id)
        target = params[:users_targets][user_id.to_s]
        puts target
        if @quarter.assignations.exists?(user_id: user.id)
          @quarter.assignations.where(user_id: user.id).update_all(
            month_target_1: target["0"].to_f,
            month_target_2: target["1"].to_f,
            month_target_3: target["2"].to_f)
        else
          @quarter.assignations.create(user_id: user.id,
            month_target_1: target["0"].to_f,
            month_target_2: target["1"].to_f,
            month_target_3: target["2"].to_f)
        end
      end
    end

    respond_to do |format|
      if updated
        format.html { redirect_to @quarter, notice: 'Quarter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quarter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quarters/1
  # DELETE /quarters/1.json
  def destroy
    @quarter = Quarter.find(params[:id])
    @quarter.destroy

    respond_to do |format|
      format.html { redirect_to quarters_url }
      format.json { head :no_content }
    end
  end

  protected

  def ensure_admin!
    redirect_to '/', :status => 404 unless current_user.is_admin
  end
end
