class PromptController < ApplicationController
  before_action :set_works
  before_action :authenticate_admin, only: [:database]

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
