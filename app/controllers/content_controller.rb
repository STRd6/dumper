require 'net/http'

class ContentController < ApplicationController
  before_action :require_account, except: [:show, :index]
  before_action :set_content, only: [:show, :edit, :update, :destroy]

  skip_before_action :verify_authenticity_token

  # GET /contents
  # GET /contents.json
  def index
    @contents = Content.all
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
  end

  def policy
    # Return a signed s3 policy that an acconut can use to upload to
    policy = Policy.generate namespace: "/u/#{current_account.id}/"

    render json: policy
  end

  def copy
    # Copy a verified object from a sub-s3 folder to
    # the main one
  end

  def email
    # TODO: Compute sha256 and mime of attachments
    # Do basically the same as slurp
    # Add Email tag
  end

  def upload
    content_items = params["content"]["upload"].map do |file|
      logger.info file

      content = Content.from_file(file, file.content_type)

      content.add_tags_for_account(current_account, [
        "Upload",
        "Uncategorized"
      ])
      content.save

      content
    end

    render json: content_items
  end

  def slurp
    # Ingest content from a url
    url = params[:url]

    logger.info "Slurped"

    content = Content.new.slurp(url)

    if content
      logger.info "Slurped"
      content.add_tags_for_account(current_account, [
        "Slurp",
        "Uncategorized"
      ])
      content.save!

      render json: content
    else
      # TODO: Can we be more specific with our errors?
      render json: {error: "Failed to slurp", status: 422}
    end
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(content_params)

    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Content was successfully created.' }
        format.json { render :show, status: :created, location: @content }
      else
        format.html { render :new }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to @content, notice: 'Content was successfully updated.' }
        format.json { render :show, status: :ok, location: @content }
      else
        format.html { render :edit }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_params
      params.require(:content).permit(:sha256, :mime_type, :size)
    end
end
