#

namespace 'picture_haus' do
  desc 'import'
  task 'import' => :environment do
    DASHES = "--"
    BOUNDARY = "2383320045889895731395624388"

    def extract_cookies(resp)
      all_cookies = resp.get_fields('Set-Cookie')
      cookies_array = Array.new
      all_cookies.each { | cookie |
          cookies_array.push(cookie.split('; ')[0])
      }
      return cookies_array.join('; ')
    end

    def extract_csrf_hash(resp)
      html_doc = Nokogiri::HTML(resp.body)
      csrf_param = html_doc.xpath('//meta[@name="csrf-param"]').first["content"]
      csrf_token = html_doc.xpath('//meta[@name="csrf-token"]').first["content"]
      return { csrf_param => csrf_token }
    end

    directory_of_tagged_photos = ENV['DIR_OF_TAGGED_PHOTOS']
    raise "please set DIR_OF_TAGGED_PHOTOS=some/dir/of/pics" unless directory_of_tagged_photos && Dir.exists?(directory_of_tagged_photos)

    picture_haus_host = "localhost"
    picture_haus_port = 4444
    picture_haus_username = ""
    picture_haus_password = ""

    http = Net::HTTP.new(picture_haus_host, picture_haus_port)
    http.use_ssl = false
    sign_in_path = "/people/sign_in"
    new_finding_path = "/findings/new"
    findings_path = "/findings"

    response = http.get(sign_in_path)
    if response.is_a?(Net::HTTPOK)
      request = Net::HTTP::Post.new(sign_in_path)
      request.set_form_data({
        "utf8" => "✓",
        "person[email]" => picture_haus_username,
        "person[password]" => picture_haus_password,
        "person[remember_me]" => "1"
      }.merge(extract_csrf_hash(response)))
      request["Cookie"] = extract_cookies(response)

      signed_in_response = http.request(request)

      if signed_in_response.is_a?(Net::HTTPFound)

        new_finding_response = http.get(new_finding_path, { "Cookie" => extract_cookies(signed_in_response) })

        csrf_token = extract_csrf_hash(new_finding_response)

        image_to_import = ""

        post_body = []

        post_body << "#{DASHES}#{BOUNDARY}\r\n"

        post_body << "Content-Disposition: form-data; name=\"#{csrf_token.keys[0]}\"\r\n"
        post_body << "\r\n"
        post_body << "#{csrf_token.values[0]}\r\n"

        post_body << "#{DASHES}#{BOUNDARY}\r\n"

        post_body << "Content-Disposition: form-data; name=\"utf8\"\r\n"
        post_body << "\r\n"
        post_body << "✓\r\n"

        post_body << "#{DASHES}#{BOUNDARY}\r\n"

        post_body << "Content-Disposition: form-data; name=\"finding[tag_list]\"\r\n"
        post_body << "\r\n"
        post_body << "test,import\r\n"

        post_body << "#{DASHES}#{BOUNDARY}\r\n"

        post_body << "Content-Disposition: form-data; name=\"finding[image][title]\"\r\n"
        post_body << "\r\n"
        post_body << "test-title\r\n"

        post_body << "#{DASHES}#{BOUNDARY}\r\n"

        post_body << "Content-Disposition: form-data; name=\"finding[image][pending_upload]\"; filename=\"foo-bar-baz.png\"\r\n"
        post_body << "Content-Type: image/jpeg\r\n"
        post_body << "\r\n"
        post_body << File.read(image_to_import)

        post_body << "#{DASHES}#{BOUNDARY}#{DASHES}"

        post_body = post_body.join

        request = Net::HTTP::Post.new(findings_path)
        request["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"
        request["Cookie"] = extract_cookies(new_finding_response)
        request["Content-Length"] = post_body.length
        request.body = post_body

        finding_created_response = http.request(request)

        if redirect_location = finding_created_response["Location"]
          redirect_uri = URI.parse(redirect_location)
          if redirect_uri.path.starts_with?("/images/")
            puts "OK"
          end
        end
      end
    end
  end
end
