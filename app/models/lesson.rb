class Lesson < ApplicationRecord
  belongs_to :section

  mount_uploader :video, VideoUploader

  include RankedModel
  ranks :row_order, with_same: :section_id


  #!Q - how does this work?
  # => "section" loads the section that is connected to the lesson we are in, in the context of the database
  # => "section.lessons" loads all the lessons associated with the section connected to the lesson we are in
  # => "where" allows us to add SQL code within its parens
  # => in this case, the SQL snippet is asking for lessons whose row_order (RankedModel gem position) is greater than the value we specify
  # => the value we specify is the row_order value of the lesson we are in, calculated via the "self.row_order"
  # => ".rank(:row_order).first" then ranks the results returned by the code to the left by row_order, then returns the lowest value
  def next_lesson
    lesson = section.lessons.where("row_order > ?", self.row_order).rank(:row_order).first

    if lesson.blank? && section.next_section  
      return section.next_section.lessons.rank(:row_order).first
    end

    return lesson
  end
end

