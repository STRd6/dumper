require 'net/http'

class Content < ApplicationRecord
  self.table_name = "content"
  has_many :tags

  def slurp(url)
    raise "Invalid URL" unless url.starts_with?("http")
    logger = Rails.logger

    logger.info "Slurping #{url}"

    url = URI.parse(url)
    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(
      url.host, 
      url.port, 
      :use_ssl => url.scheme == 'https'
    ) {|http|
      http.request(request)
    }

    logger.info "Completed slurp"

    body = response.body
    content_type = response.content_type
    size = body.length

    logger.info "#{sha256}\ncontent-type: #{content_type}\nsize: #{size}"

    sha256 = Uploader.upload_to_s3(body, content_type)

    existing_content = Content.find_by(sha256: sha256)
    if existing_content
      # Assume it it's the same
      return existing_content
    end

    self.assign_attributes({
      sha256: sha256,
      mime_type: content_type,
      size: size
    })

    return self
  end

  def add_tags_for_account(account, tags)
    tags.each do |tag_name|
      self.tags.find_or_initialize_by({
        account: account,
        tag: tag_name
      })
    end
  end

  def self.from_file(file, content_type)
    size = file.size

    sha256 = Uploader.upload_to_s3(file.read, content_type)

    existing_content = Content.find_by(sha256: sha256)
    if existing_content
      # Assume it it's the same
      return existing_content
    end

    Content.new({
      sha256: sha256,
      mime_type: content_type,
      size: size
    })
  end
end
