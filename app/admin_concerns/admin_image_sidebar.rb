module AdminImageSidebar
  def self.included(dsl)
    dsl.sidebar :images, only: :show do
      images = resource.images.map do |image|
        link_to(
          image_tag(image.upload.url, class: 'upload-image'), [:admin, image]
        )
      end
      raw(images.join)
    end
  end
end
