"""
Redis service for caching
"""

import json
import redis
from typing import Optional, Any


class RedisService:
    """Service for Redis operations"""
    
    def __init__(self, config: dict):
        self.host = config.get('REDIS_HOST', 'localhost')
        self.port = config.get('REDIS_PORT', 6379)
        self.db = config.get('REDIS_DB', 0)
        self._client = None
    
    @property
    def client(self):
        if self._client is None:
            self._client = redis.Redis(
                host=self.host,
                port=self.port,
                db=self.db,
                decode_responses=True
            )
        return self._client
    
    def get(self, key: str) -> Optional[Any]:
        """Get value from cache"""
        try:
            value = self.client.get(key)
            if value:
                try:
                    return json.loads(value)
                except json.JSONDecodeError:
                    return value
            return None
        except redis.ConnectionError:
            return None
    
    def set(self, key: str, value: Any, ttl: int = 300) -> bool:
        """Set value in cache with TTL"""
        try:
            if isinstance(value, (dict, list)):
                value = json.dumps(value)
            return self.client.setex(key, ttl, value)
        except redis.ConnectionError:
            return False
    
    def delete(self, key: str) -> bool:
        """Delete key from cache"""
        try:
            return self.client.delete(key) > 0
        except redis.ConnectionError:
            return False
    
    def exists(self, key: str) -> bool:
        """Check if key exists"""
        try:
            return self.client.exists(key) > 0
        except redis.ConnectionError:
            return False
    
    def incr(self, key: str, amount: int = 1) -> int:
        """Increment counter"""
        try:
            return self.client.incr(key, amount)
        except redis.ConnectionError:
            return 0
    
    def expire(self, key: str, ttl: int) -> bool:
        """Set expiration on key"""
        try:
            return self.client.expire(key, ttl)
        except redis.ConnectionError:
            return False
    
    def flush_all(self) -> bool:
        """Clear all cache"""
        try:
            self.client.flushdb()
            return True
        except redis.ConnectionError:
            return False
    
    def health_check(self) -> dict:
        """Check Redis connection health"""
        try:
            self.client.ping()
            info = self.client.info()
            return {
                'status': 'healthy',
                'connected': True,
                'version': info.get('redis_version', 'unknown'),
                'db_size': self.client.dbsize()
            }
        except redis.ConnectionError as e:
            return {
                'status': 'unhealthy',
                'connected': False,
                'error': str(e)
            }