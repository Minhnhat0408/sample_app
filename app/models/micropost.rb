class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [Settings.micropost.image_height,
                                         Settings.micropost.image_width]
  end

  VALID_CONTENT = %i(content image).freeze

  scope :newest, ->{order(created_at: :desc)}

  validates :content, presence: true,
    length: {maximum: Settings.digits.digit_140}
  validates :image, content_type: {in: Settings.micropost.image_valid_format,
                                   message: I18n.t("micropost.image_format")},
                                   size: {less_than: Settings.maxsize.megabytes,
                                          message: I18n.t("micropost.size_max")}
end
