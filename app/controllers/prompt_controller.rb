class PromptController < ApplicationController
  before_action :set_works
  before_action :authenticate_admin, only: [:database]
  skip_before_action :verify_authenticity_token, only: [:beacon]

  def index
    @prompt_submission = PromptSubmission.new
  end

  def submit
    @prompt_submission = PromptSubmission.new(prompt_submission_params)
    if @prompt_submission.save
      redirect_to prompt_path, notice: "Thank you. Your submission has been archived."
    else
      render :index, status: :unprocessable_entity
    end
  end

  def database
    @submissions = PromptSubmission.order(created_at: :desc)
    render layout: false
  end

  def beacon
    Rails.cache.write('last_beacon_timestamp', Time.now.to_i, expires_in: 1.hour)
    head :no_content
  rescue StandardError => e
    Rails.logger.error("Beacon Error: #{e.message}")
    head :bad_request
  end

  def beacon_status
    timestamp = Rails.cache.read('last_beacon_timestamp') || 0
    render json: { latest_timestamp: timestamp }
  end

  private

  def prompt_submission_params
    params.require(:prompt_submission).permit(:name, :email, :prompt_text, :answer_text)
  end

  def authenticate_admin
    password = ENV["PROMPT_DATABASE_PASSWORD"]
    unless password.present?
      head :forbidden
      return
    end

    authenticate_or_request_with_http_basic("Prompt Database") do |username, pwd|
      ActiveSupport::SecurityUtils.secure_compare(username, "admin") &
        ActiveSupport::SecurityUtils.secure_compare(pwd, password)
    end
  end
end
