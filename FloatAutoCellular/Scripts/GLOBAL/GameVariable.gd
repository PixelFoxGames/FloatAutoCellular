extends Node

var IsPlaying:bool = true;
var IsMovePhoto:bool = false;
var IsDot:bool = true;

var LiveColorR:float = 1;
var LiveColorG:float = 1;
var LiveColorB:float = 1;
var DieColorR:float = 0;
var DieColorG:float = 0;
var DieColorB:float = 0;

var ScreenCenterPosition:Vector2;
func UpdateScreenCenterPosition(screenCenterPos):
	ScreenCenterPosition = screenCenterPos;

func ChangeRunPauseMode(isPlaying: bool) -> void:
	IsPlaying = isPlaying;

func ChangeToMovePhotoMode() -> void:
	IsMovePhoto = true;

func ChangeToSetCellMode(isDot: bool) -> void:
	IsMovePhoto = false;
	IsDot = isDot;
