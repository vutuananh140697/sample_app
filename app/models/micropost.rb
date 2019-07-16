class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_desc, ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.maximum_micropost_content_length}
  validate  :picture_size

  private

  def picture_size
    errors.add(:picture, t("image_size")) if picture.size >
                                             Settings.picture_size.megabytes
  end
end
