class User < ApplicationRecord
  has_many :courses
  has_many :enrollments
  has_many :enrolled_courses, through: :enrollments, source: :course


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def enrolled_in?(course)
    # enrolled_courses = []
    # enrollments.each do |enrollment|
    #   enrolled_courses << enrollment.course
    # end

    # return enrolled_courses.include?(course)

    # can also be written using a collector, as below
    # enrolled_courses = enrollments.collect do |enrollment|
    #   enrollment.course
    # end
    # return enrolled_courses.include?(course)

    #CAN ALSO BE WRITTEN USING A HAS-MANY :THROUGH RELATIONSHOP
    return enrolled_courses.include?(course)
  end

end
