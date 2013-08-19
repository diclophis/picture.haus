require 'imageseek'

$imageseek_databases = ImageSeek.databases

$imageseek_database = $imageseek_databases.first 

unless $imageseek_database
  $imageseek_database = "index-000" # Time.now.to_i || rand ?
  ImageSeek.create($imageseek_database)
end
