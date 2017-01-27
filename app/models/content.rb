require 'net/http'
require 'aws-sdk'

class Content < ApplicationRecord
  self.table_name = "content"
  belongs_to :account
  has_many :tags

  def slurp(url, account)
    raise "Invalid URL" unless url.starts_with?("http")

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

    logger.info "read body"
    content_type = response.content_type
    sha256 = Digest::SHA256.hexdigest body
    size = -1# body.length

    logger.info "#{sha256}\ncontent-type: #{content_type}\nsize: #{size}"

    existing_content = Content.find_by(sha256: sha256)
    if existing_content
      # Assume it it's the same
      return existing_content
    end

    bucket = ENV["S3_BUCKET"]
    key = "data/#{sha256}"
    # TODO: Upload to S3
    s3 = Aws::S3::Client.new

    begin
      object_response = s3.head_object({
        bucket: bucket,
        key: key
      })

      exists = true
    rescue Aws::S3::Errors::NotFound
      exists = false
    end

    if exists
      # Do nothing, assume it is the same
      logger.info "object found in s3 at #{bucket}/#{key}"
    else
      logger.info "writing to s3 at #{bucket}/#{key}"
      s3.put_object({
        body: body,
        bucket: bucket,
        cache_control: "public, max-age=31536000",
        content_type: content_type,
        key: key
      })
    end

    self.assign_attributes({
      account: account,
      sha256: sha256,
      mime_type: content_type,
      size: size
    })

    return self
  end
end
