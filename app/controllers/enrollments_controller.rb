class EnrollmentsController < ApplicationController
  before_action :authenticate_user!

  def new
  end


  def create

    if current_course.premium?
      #STRIPE 
      # Amount in cents
      @amount = (current_course.cost * 100).to_i

      #!Q - these are classes/subclasses. Where are they located?
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )

      #!Q - where is customer.id coming from? We created customer, but what about id?
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Flixter Primo Content',
        :currency    => 'usd'
      )

    end
    #gotta charge first before enrollment
    current_user.enrollments.create(course: current_course)
    redirect_to course_path(current_course)

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to root_path

  end

  ####Could also write like:
  # def create
  #   Enrollment.create(course: current_course, user: current_user)
  # end


  private

  def current_course
    @current_course ||= Course.find(params[:course_id])
  end

end
