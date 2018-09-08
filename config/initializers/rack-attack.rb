class Rack::Attack
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  throttle('limit contact form', limit: 3, period: 15.minutes) do |req|
    if req.path == '/contact' && req.post?
      req.ip
    end
  end
end
