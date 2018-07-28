class Instructor::SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_current_course, only: [:create]
  before_action :require_authorized_for_current_section, only: [:update]

  # Because we put the functinality of creating a new section within a modal on the show courses page, we no longer need this controller action - there is no new section page anymore
  # def new
  #   @section = Section.new
  # end

  def create
    @section = current_course.sections.create(section_params)
    redirect_to instructor_course_path(current_course)
  end

  def update
    current_section.update_attributes(section_params)
    render plain: 'Updated! Section: ' + current_section.title.to_s + ' within Course: ' + current_section.course.title.to_s
  end

  private



  def require_authorized_for_current_course
    if current_course.user != current_user
      render plain: "Unauthorized", status: :unauthorized
    end
  end

  def require_authorized_for_current_section
    if current_section.course.user != current_user
      render plain: "Unauthorized", status: :unauthorized
    end
  end


  helper_method :current_course
  def current_course
    @current_course ||= Course.find(params[:course_id])
  end

  def current_section
    @current_section ||= Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:title, :row_order_position)
  end

end
