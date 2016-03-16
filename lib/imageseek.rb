#require 'xmlrpc/client'
require 'open-uri'
require 'net/http'

class ImageSeek
  HOST = "localhost"
  PORT = 31128
  IMGSEEK_CMD = "#{ENV['IMGSEEK']} 2>&1"
  ES_HOST = ENV["ELASTICSEARCH_HOST"]
  ES_PORT = ENV["ELASTICSEARCH_PORT"].to_i

  def self.client
    #client = XMLRPC::Client.new(HOST, "/RPC", PORT)
  end

  def self.daemon
=begin
    IO.popen(IMGSEEK_CMD) { |io|
      i = ""
      thread = Thread.new { #TODO: try without thread
        while IO.select([io], nil, nil) do
          i = io.gets
          #puts i if ENV['DEBUG_IMGSEEK']
          #puts "\e[32m.\e[0m" if Rails.env.test
          #i.length.times { $stdout.write(".") } if Rails.env.test
          #$stdout.flush
          break if i.nil?
        end
      }
      sleep 0.1 until i && i.include?("init finished") #TODO: remove sleep idle loop
      begin
        yield
      rescue => problem
        raise problem
      ensure
        self.shutdown
        thread.join
      end
    }
=end
    yield
  end


  def self.add_image(image_id, image_path, is_url = true)
    image_url = URI.parse(image_path)
    key = File.basename(image_url.path)

    bucket = ENV["AWS_S3_BUCKET"]
    connection = Fog::Storage.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => ENV["AWS_S3_ACCESS_KEY_ID"],
      :aws_secret_access_key    => ENV["AWS_S3_SECRET_KEY"],
      :region                   => ENV["AWS_S3_REGION"]
    })

    directory = connection.directories.get(bucket) || connection.directories.create(:key => bucket, :public => true)
    image_io = directory.files.get(key)

    indexed_image_id = nil
    image_base64 = Base64.encode64(image_io.body)
    http = Net::HTTP.new(ES_HOST, ES_PORT)
    json_body = {
      "image_id" => image_id.to_s,
      "my_img" => image_base64
    }.to_json
    response = http.request_post('/test/test?refresh=true', json_body)
    if response.is_a?(Net::HTTPCreated)
      parsed_body = JSON.parse(response.body)
      indexed_image_id = parsed_body["_id"]
    end
    indexed_image_id
  end

  def self.find_images_similar_to(image_id, count = 10)
    http = Net::HTTP.new(ES_HOST, ES_PORT)
    json_body = {
      "fields" => ["image_id"],
      "size" => count,
      "query" => {
          "image" => {
              "my_img" => {
                  "feature" => "CEDD",
                  "index" => "test",
                  "type" => "test",
                  "id" => image_id.to_s,
                  "hash" => "BIT_SAMPLING"
              }
          }
      }
    }.to_json
    response = http.request_post('/test/test/_search', json_body)
    if response.is_a?(Net::HTTPOK)
      response_struct = JSON.parse(response.body)
      if has_hits = response_struct["hits"]
        hits = has_hits["hits"]
        return hits.collect do |hit|
          [hit["_id"], hit["_score"]]
        end
      end
    end

    return []
  rescue
    []
  end
end
