class FoosController < ApplicationController
  # GET /foos
  # GET /foos.json
  def index
    @foos = Foo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @foos }
    end
  end

  # GET /foos/1
  # GET /foos/1.json
  def show
    @foo = Foo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @foo }
    end
  end

  # GET /foos/new
  # GET /foos/new.json
  def new
    @foo = Foo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @foo }
    end
  end

  # GET /foos/1/edit
  def edit
    @foo = Foo.find(params[:id])
  end

  # POST /foos
  # POST /foos.json
  def create
    @foo = Foo.new(params[:foo])

    respond_to do |format|
      if @foo.save
        format.html { redirect_to @foo, notice: 'Foo was successfully created.' }
        format.json { render json: @foo, status: :created, location: @foo }
      else
        format.html { render action: "new" }
        format.json { render json: @foo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /foos/1
  # PUT /foos/1.json
  def update
    @foo = Foo.find(params[:id])

    respond_to do |format|
      if @foo.update_attributes(params[:foo])
        format.html { redirect_to @foo, notice: 'Foo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @foo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foos/1
  # DELETE /foos/1.json
  def destroy
    @foo = Foo.find(params[:id])
    @foo.destroy

    respond_to do |format|
      format.html { redirect_to foos_url }
      format.json { head :no_content }
    end
  end
end
