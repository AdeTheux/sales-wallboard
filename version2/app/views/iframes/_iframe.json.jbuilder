json.extract! iframe, :id, :title, :url, :department, :created_at, :updated_at
json.url iframe_url(iframe, format: :json)