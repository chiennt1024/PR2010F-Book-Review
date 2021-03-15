class Book < ApplicationRecord
	has_one_attached :image
	belongs_to :category
	belongs_to :author
	has_many :favorites
	has_many :rates
	has_many :reviews
	delegate :name, to: :author, prefix: :author, allow_nil: true
	delegate :name, to: :category, prefix: :category, allow_nil: true
	validates :category_id, presence: true
	validates :author_id, presence: true
	validates :name, presence: true
  validates :description, presence: true
  validates_length_of :description, :maximum => 244
	validates :image, content_type: {
		in: %w[image/jpeg image/gif image/png],
		message: "must be a valid image format" },
		size: { less_than: 5.megabytes,
			message: "should be less than 5MB" }
	scope :book_by, ->field_name, value, value2 {where(
    "#{field_name} LIKE ? OR #{field_name} LIKE ?",
    value,
    value2
   )}
	class << self
  	def search_book(value)
    	@reviews = Book.book_by("name", "% " + value + "%", value + "%")
  	end
	end
	# Returns a resized image for display.
	def display_image width, height
		# Normal size 250, 357
		image.variant(resize_to_fill: [width, height])
	end
end
