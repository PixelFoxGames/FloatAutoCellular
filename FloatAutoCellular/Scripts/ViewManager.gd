extends Node2D

var timer:float = 999;
var x1:int; var x2:int; var y1:int; var y2:int;
@onready var main_camera = $"../MainCamera"

func _ready() -> void:
	var screenSize:Vector2 = DisplayServer.window_get_size();
	var screenWidth:int = int(screenSize.x);
	var screenHeight:int = int(screenSize.y);
	while screenHeight > 500 || screenWidth > 500:
		screenHeight /= 2;
		screenWidth /= 2;
	MatrixVariable.InitTimerValue(1, 1, 1);
	timer = 999;
	InitGame(screenWidth, screenHeight);
	
func InitGame(matrixWidth, matrixLength):
	MatrixVariable.InitMatrix(matrixWidth, matrixLength);
	main_camera.InitToCenter();
	SimpleRedraw();
	
func _draw() -> void:
	if MatrixVariable.Matrix == null:
		return;
	var dieColorR = GameVariable.DieColorR;
	var dieColorG = GameVariable.DieColorG;
	var dieColorB = GameVariable.DieColorB;
	var growColorR = GameVariable.LiveColorR - dieColorR;
	var growColorG = GameVariable.LiveColorG - dieColorG;
	var growColorB = GameVariable.LiveColorB - dieColorB;
	var cellHP:float;
	for x in range(x1, x2 + 1):
		for y in range(y1, y2 + 1):
			cellHP = MatrixVariable.Matrix.AnimFloatMatrix[x][y];
			draw_rect(Rect2(x * 10, y * 10, 7, 7), Color(dieColorR+cellHP*growColorR, dieColorG+cellHP*growColorG, dieColorB+cellHP*growColorB));
	
func UpdateFieldOfView() -> void:
	var halfWindowSize:Vector2 = DisplayServer.window_get_size() / 2;
	var cameraZoom:float = main_camera.zoom.x;
	var LeftTopPos:Vector2 = GameVariable.ScreenCenterPosition - halfWindowSize / cameraZoom;
	var RightBottonPos:Vector2 = GameVariable.ScreenCenterPosition + halfWindowSize / cameraZoom;
	x1 = int(LeftTopPos.x / 10) - 1;
	x2 = int(RightBottonPos.x / 10) + 1;
	y1 = int(LeftTopPos.y / 10) - 1;
	y2 = int(RightBottonPos.y / 10) + 1;
	if x1 < 1: 
		x1 = 1;
	if y1 < 1: 
		y1 = 1;
	if x2 > MatrixVariable.Matrix.MatrixWidth - 2:
		x2 = MatrixVariable.Matrix.MatrixWidth - 2;
	if y2 > MatrixVariable.Matrix.MatrixLength - 2:
		y2 = MatrixVariable.Matrix.MatrixLength - 2;
	if GameVariable.IsPlaying == false:
		MatrixVariable.CalcUpdate(x1, x2, y1, y2, timer);

func _process(delta:float) -> void:
	UpdateFieldOfView();
	if GameVariable.IsPlaying == false:
		return;
	timer += delta;
	if timer < MatrixVariable.CalcIntervals:
		RedrawUpdate();
	else:
		RedrawNextRound();
		timer = 0;
	pass

func RedrawUpdate():
	MatrixVariable.CalcUpdate(x1, x2, y1, y2, timer);
	queue_redraw();

func RedrawNextRound():
	MatrixVariable.CalcNextRound();
	queue_redraw();

func SimpleRedraw():
	UpdateFieldOfView();
	queue_redraw();
