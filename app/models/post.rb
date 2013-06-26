class Post < ActiveRecord::Base
  attr_accessible :title, :content, :is_published

  scope :recent, order: "created_at DESC", limit: 5

  before_save :titleize_title
  before_save :slug_it_up

  validates_presence_of :title, :content

  private

  def titleize_title
    self.title = title.titleize
  end

  def slug_it_up
    self.slug = title.downcase.gsub(" ", "-").gsub(/[\!\.\?'"]/, "")
  end
end
