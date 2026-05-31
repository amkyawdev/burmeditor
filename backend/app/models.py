"""
Database models for Burme Editor
"""

from datetime import datetime
from typing import Optional, List
import json


class BaseModel:
    """Base model with common functionality"""
    
    def to_dict(self):
        result = {}
        for key, value in self.__dict__.items():
            if not key.startswith('_'):
                if isinstance(value, datetime):
                    result[key] = value.isoformat()
                elif isinstance(value, list):
                    result[key] = [item.to_dict() if hasattr(item, 'to_dict') else item for item in value]
                elif hasattr(value, 'to_dict'):
                    result[key] = value.to_dict()
                else:
                    result[key] = value
        return result
    
    def to_json(self):
        return json.dumps(self.to_dict())
    
    @classmethod
    def from_dict(cls, data):
        if data is None:
            return None
        instance = cls()
        for key, value in data.items():
            if hasattr(instance, key):
                setattr(instance, key, value)
        return instance


class Project(BaseModel):
    """Video editing project model"""
    
    def __init__(
        self,
        id: str = None,
        name: str = None,
        created_at: datetime = None,
        updated_at: datetime = None,
        duration: float = 0.0,
        resolution: tuple = (1920, 1080),
        fps: float = 30.0,
        clips: List = None,
        settings: dict = None
    ):
        self.id = id
        self.name = name
        self.created_at = created_at or datetime.now()
        self.updated_at = updated_at or datetime.now()
        self.duration = duration
        self.resolution = resolution
        self.fps = fps
        self.clips = clips or []
        self.settings = settings or {}


class VideoClip(BaseModel):
    """Video clip model"""
    
    def __init__(
        self,
        id: str = None,
        file_path: str = None,
        start_time: float = 0.0,
        end_time: float = 0.0,
        in_point: float = 0.0,
        out_point: float = 0.0,
        speed: float = 1.0,
        volume: float = 1.0,
        filters: List = None,
        effects: List = None
    ):
        self.id = id
        self.file_path = file_path
        self.start_time = start_time
        self.end_time = end_time
        self.in_point = in_point
        self.out_point = out_point
        self.speed = speed
        self.volume = volume
        self.filters = filters or []
        self.effects = effects or []


class Subtitle(BaseModel):
    """Subtitle model"""
    
    def __init__(
        self,
        id: str = None,
        text: str = None,
        start_time: float = 0.0,
        end_time: float = 0.0,
        style: dict = None,
        position: dict = None
    ):
        self.id = id
        self.text = text
        self.start_time = start_time
        self.end_time = end_time
        self.style = style or {
            'font': 'Pyidaungsu',
            'size': 24,
            'color': '#FFFFFF',
            'background': '#000000'
        }
        self.position = position or {'x': 'center', 'y': 'bottom'}


class ExportJob(BaseModel):
    """Export job model"""
    
    def __init__(
        self,
        id: str = None,
        project_id: str = None,
        status: str = 'pending',
        progress: float = 0.0,
        output_format: str = 'mp4',
        output_path: str = None,
        settings: dict = None,
        error: str = None,
        created_at: datetime = None,
        completed_at: datetime = None
    ):
        self.id = id
        self.project_id = project_id
        self.status = status
        self.progress = progress
        self.output_format = output_format
        self.output_path = output_path
        self.settings = settings or {}
        self.error = error
        self.created_at = created_at or datetime.now()
        self.completed_at = completed_at


class ToolSettings(BaseModel):
    """Tool settings model"""
    
    def __init__(
        self,
        tool_id: str = None,
        name: str = None,
        parameters: dict = None,
        presets: List = None
    ):
        self.tool_id = tool_id
        self.name = name
        self.parameters = parameters or {}
        self.presets = presets or []


# Tool IDs
class ToolIDs:
    CROP = 'crop'
    AUDIO = 'audio'
    COLOR = 'color'
    TEXT = 'text'
    TITLE = 'title'
    LAYERING = 'layering'
    TRANSFORM = 'transform'
    SPEED = 'speed'
    TRANSITION = 'transition'
    EFFECTS = 'effects'
    MASKING = 'masking'
    STABILIZE = 'stabilize'
    IMAGE_OVERLAY = 'image_overlay'
    SUBTITLES = 'subtitles'
    EXPORT = 'export'
    
    @classmethod
    def all_tools(cls):
        return [
            cls.CROP, cls.AUDIO, cls.COLOR, cls.TEXT, cls.TITLE,
            cls.LAYERING, cls.TRANSFORM, cls.SPEED, cls.TRANSITION,
            cls.EFFECTS, cls.MASKING, cls.STABILIZE, cls.IMAGE_OVERLAY,
            cls.SUBTITLES, cls.EXPORT
        ]