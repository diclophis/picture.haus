require 'xmlrpc/client'

class ImageSeek
  HOST = "localhost"
  PORT = 31128
  IMGSEEK_CMD = "#{ENV['IMGSEEK']} 2>&1"
  def self.client
  client = XMLRPC::Client.new(HOST, "/RPC", PORT)
  end
  def self.daemon
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
  end
  def self.shutdown
    return client.call('shutdownServer')
  end
  def self.databases
    return client.call('getDbList')
  end
  def self.save_databases
    return client.call('saveAllDbs')
  end
  def self.create(id)
    return client.call('createDb', id.to_i)
  end
  def self.reset_database(id)
    return client.call('resetDb', id.to_i)
  end
  def self.clusters(id, count = 10)
    return client.call('getClusterDb', id.to_i, count)
  end
  def self.add_image(database_id, image_id, image_path, is_url = true)
    unless client.call('isImgOnDb', database_id.to_i, image_id.to_i)
      return client.call('addImg', database_id.to_i, image_id.to_i, image_path, is_url)
    end
  end
  def self.add_keyword_to_image(database_id, image_id, keyword)
    return client.call('addKeywordImg', database_id.to_i, image_id.to_i, keyword)
  end
  def self.add_keywords_to_image(database_id, image_id, keywords)
    return client.call('addKeywordsImg', database_id.to_i, image_id.to_i, keywords)
  end
  def self.find_keywords_for(database_id, image_id)
    return client.call('getKeywordsImg', database_id.to_i, image_id.to_i)
  end
  def self.find_images_similar_to(database_id, image_id, count = 10)
    return client.call('queryImgID', database_id.to_i, image_id.to_i, count)
  rescue
    []
  end
  def self.find_images_similar_with_keywords_to(database_id, image_id, count = 10, keywords = "", join = 0)
    return client.call('queryImgIDKeywords', database_id.to_i, image_id.to_i, count, join, keywords)
  rescue
    []
  end
end
