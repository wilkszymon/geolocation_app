class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

  throttle('req/ip', limit: 2, period: 5) do |req|
    req.ip
  end

  self.throttled_response = lambda do |env|
    [429, { 'Content-Type' => 'application/json' }, [{ error: 'Throttle limit reached. Retry later.', status: 429 }.to_json]]
  end
end
