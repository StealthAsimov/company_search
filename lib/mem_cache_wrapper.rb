module MemCacheWrapper
  require 'memcache'
  def self.get_memcache(host)
    return MemCache.new(host)
  end
end
