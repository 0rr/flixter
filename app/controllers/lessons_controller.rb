class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_enrollment_to_view_lesson, only: [:show]


  def show
  end

  private

  def require_enrollment_to_view_lesson
    if !current_user.enrolled_in?(current_lesson.section.course)
      redirect_to course_url(current_lesson.section.course), alert: "You've gotta enroll"
    end
  end

  helper_method :current_lesson
  def current_lesson
    @current_lesson ||= Lesson.find(params[:id])
  end


end
