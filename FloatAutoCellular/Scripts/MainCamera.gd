extends Camera2D

var lastMousePosition:Vector2;
var currentPhotoZoom:float;

@onready var view_manager = $"../ViewManager"

func _ready() -> void:
	pass

func InitToCenter() -> void:
	position = Vector2(MatrixVariable.Matrix.MatrixWidth * 5, MatrixVariable.Matrix.MatrixLength * 5);
	GameVariable.ScreenCenterPosition = position;
	pass

func _process(_delta) -> void:
	if Input.is_action_just_pressed("MouseScollDown"):
		var newZoom:float = zoom.x * 0.9;
		if newZoom < 0.1:
			newZoom = 0.1;
		zoom = Vector2(newZoom, newZoom);
		view_manager.UpdateFieldOfView();
	elif Input.is_action_just_pressed("MouseScrollUp"):
		var newZoom:float = zoom.x * 1.1;
		if newZoom > 5:
			newZoom = 5;
		zoom = Vector2(newZoom, newZoom);
		view_manager.UpdateFieldOfView();

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		MoveCamera();

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if GameVariable.IsMovePhoto:
			MoveCamera();
		else:
			ChangeCellState();

func _input(event) -> void:
	if event is InputEventMouseButton: # Ready for move camera
		lastMousePosition = get_viewport().get_mouse_position();
		GameVariable.ScreenCenterPosition = get_screen_center_position();

func MoveCamera() -> void:
	var currentMousePosition:Vector2 = get_viewport().get_mouse_position();
	var newCameraPosition = position - (currentMousePosition - lastMousePosition) / zoom.x;
	if newCameraPosition.x < 0:
		newCameraPosition.x = 0;
	if newCameraPosition.y < 0:
		newCameraPosition.y = 0;
	if newCameraPosition.x > MatrixVariable.Matrix.MatrixWidth * 10:
		newCameraPosition.x = MatrixVariable.Matrix.MatrixWidth * 10;
	if newCameraPosition.y > MatrixVariable.Matrix.MatrixLength * 10:
		newCameraPosition.y = MatrixVariable.Matrix.MatrixLength * 10;

	position = newCameraPosition;
	lastMousePosition = currentMousePosition;
	GameVariable.ScreenCenterPosition = get_screen_center_position();
	view_manager.SimpleRedraw();

func ChangeCellState() -> void:
	var localMousePosition:Vector2 = get_viewport().get_mouse_position();
	var halfWindowSize:Vector2 = DisplayServer.window_get_size() / 2;
	var localMouseRelativePostion:Vector2 = (halfWindowSize - localMousePosition) / zoom.x;
	var mousePositionOnMatrix:Vector2 = position - localMouseRelativePostion;

	var posX:int = int(mousePositionOnMatrix.x / 10);
	var posY:int = int(mousePositionOnMatrix.y / 10);
	if MatrixVariable.SetCellStateInMatrix(posX, posY, GameVariable.IsDot):
		pass
	if GameVariable.IsPlaying == false:
		view_manager.SimpleRedraw();
