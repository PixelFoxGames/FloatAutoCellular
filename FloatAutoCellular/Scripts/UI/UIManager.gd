extends CanvasLayer

@onready var view_manager = $"../ViewManager"

@onready var button_show_ui = $ButtonShowUI
@onready var v_box_container = $HBoxContainer/VBoxContainer
@onready var setup_ui = $HBoxContainer/ScrollContainer

func _ready():
	SetUIVisible(true);
	live_r_edit.text = str(GameVariable.LiveColorR);
	live_g_edit.text = str(GameVariable.LiveColorG);
	live_b_edit.text = str(GameVariable.LiveColorB);
	die_r_edit.text = str(GameVariable.DieColorR);
	die_g_edit.text = str(GameVariable.DieColorG);
	die_b_edit.text = str(GameVariable.DieColorB);
	
	setup_ui.visible = false;
	AdjustTimeValueEditText();
	AdjustRuleValueEditText();
	
	UpdateLiveColorRect();
	UpdateDieColorRect();

func _on_button_setup_button_down():
	setup_ui.visible = not setup_ui.visible;
	if setup_ui.visible:
		AdjuatMatrixWidthLengthEditText();
		AdjustKeepMeanItemList();

func _on_empty_button_button_down():
	GameVariable.ChangeToSetCellMode(false);

func _on_dot_button_button_down():
	GameVariable.ChangeToSetCellMode(true);
	
func _on_move_photo_button_button_down():
	GameVariable.ChangeToMovePhotoMode();

func _on_hide_button_button_down():
	SetUIVisible(false);

func _on_button_show_ui_button_down():
	SetUIVisible(true);

func SetUIVisible(isShow: bool) -> void:
	v_box_container.visible = isShow;
	button_show_ui.visible = not isShow;
	if not isShow:
		setup_ui.visible = false;

################################################################################
# text to float value
func CheckIfStrIsNumber(text:String) -> bool:
	var dotCount:int = 0;
	for t in text:
		if (t < '0' or t > '9'):
			return false
		elif t == '.':
			dotCount += 1;
			if dotCount > 1:
				return false;
		else:
			return false;
	return true;

func RemoveNonNumericPartsOfStr(text:String) -> String:
	var newText:String = "";
	var dotCount:int = 0;
	for t in text:		
		if (t < '0' or t > '9'):#not number
			if t == '.':#is dot
				dotCount += 1;
				if dotCount < 2:
					newText += t;
		else:#is number
			newText += t;
	if newText.length() < 1:
		newText = "0";
	return newText;

func OnChangeEditText(editText:LineEdit, newText:String, maxNum:float = 1, minNum:float = 0) -> float:
	var hasChange:bool = false;
	if CheckIfStrIsNumber(newText) == false:
		newText = RemoveNonNumericPartsOfStr(newText);
		hasChange = true;
	var newNumber:float = float(newText);
	if newNumber > maxNum:
		newNumber = maxNum;
		newText = str(newNumber);
		hasChange = true;
	elif newNumber < minNum:
		newNumber = minNum;
		newText = str(newNumber);
		hasChange = true;
		
	if hasChange:
		editText.text = newText;
		editText.caret_column = newText.length();

	return newNumber;
################################################################################
# text to int value
func CheckIfStrIsInt(text:String) -> bool:
	for t in text:
		if (t < '0' or t > '9'):
			return false
	return true;
func RemoveNotIntPartsOfStr(text:String) -> String:
	var newText:String = "";
	for t in text:		
		if (t < '0' or t > '9'):#not number
			pass
		else:#is number
			newText += t;
	if newText.length() < 1:
		newText = "0";
	return newText;
func OnChangeEditIntVarText(editText:LineEdit, newText:String, maxNum:int, minNum:int) -> float:
	var hasChange:bool = false;
	if CheckIfStrIsInt(newText) == false:
		newText = RemoveNotIntPartsOfStr(newText);
		hasChange = true;
	var newNumber:int = int(newText);
	if newNumber > maxNum:
		newNumber = maxNum;
		newText = str(newNumber);
		hasChange = true;
	elif newNumber < minNum:
		newNumber = minNum;
		newText = str(newNumber);
		hasChange = true;
	if hasChange:
		editText.text = newText;
		editText.caret_column = newText.length();
	return newNumber;
################################################################################
# Adjust Edit text value
func AdjustRuleValueEditText() -> void:
	less_live_more_die_edit.text = str(MatrixVariable.NeighboorLessLiveMoreDie);
	less_keep_more_live_edit.text = str(MatrixVariable.NeighboorLessKeepMoreLive);
	less_die_more_keep_edit.text = str(MatrixVariable.NeighboorLessDieMoreKeep);
func AdjustTimeValueEditText() -> void:
	growth_time_edit.text = str(MatrixVariable.CellGrowSpendTime);
	apoptosis_time_edit.text = str(MatrixVariable.CellDieSpendTime);
	calc_interval_edit.text = str(MatrixVariable.CalcIntervals);
func AdjuatMatrixWidthLengthEditText() -> void:
	matrix_width_edit.text = str(MatrixVariable.MatrixWidth);
	matrix_length_edit.text = str(MatrixVariable.MatrixLength);
func AdjustKeepMeanItemList() -> void:
	if MatrixVariable.Matrix.IsKeepMeansKeepCellHp:
		keep_mean_item_list.select(0);
	else:
		keep_mean_item_list.select(1);
################################################################################
# Color
@onready var live_color_rect = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/LiveColor/LiveColorRect
@onready var die_color_rect = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/DieColor/DieColorRect
@onready var button_dot = $HBoxContainer/VBoxContainer/ButtonDot
@onready var button_empty = $HBoxContainer/VBoxContainer/ButtonEmpty
func UpdateLiveColorRect() -> void:
	var color:Color = Color(GameVariable.LiveColorR, GameVariable.LiveColorG, GameVariable.LiveColorB);	
	live_color_rect.color = color;
	button_dot.modulate = color;
func UpdateDieColorRect() -> void:
	var color:Color = Color(GameVariable.DieColorR, GameVariable.DieColorG, GameVariable.DieColorB);
	die_color_rect.color = color;
	button_empty.modulate = color;

@onready var live_r_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/LiveColor/Live_R_Edit
@onready var live_g_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/LiveColor/Live_G_Edit
@onready var live_b_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/LiveColor/Live_B_Edit
@onready var die_r_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/DieColor/Die_R_Edit
@onready var die_g_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/DieColor/Die_G_Edit
@onready var die_b_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/DieColor/Die_B_Edit
func _on_live_r_edit_text_changed(new_text):
	GameVariable.LiveColorR = OnChangeEditText(live_r_edit, new_text, 1, 0);
	UpdateLiveColorRect();
func _on_live_g_edit_text_changed(new_text):
	GameVariable.LiveColorG = OnChangeEditText(live_g_edit, new_text, 1, 0);
	UpdateLiveColorRect();
func _on_live_b_edit_text_changed(new_text):
	GameVariable.LiveColorB = OnChangeEditText(live_b_edit, new_text, 1, 0);
	UpdateLiveColorRect();
func _on_die_r_edit_text_changed(new_text):
	GameVariable.DieColorR = OnChangeEditText(die_r_edit, new_text, 1, 0);
	UpdateDieColorRect();
func _on_die_g_edit_text_changed(new_text):
	GameVariable.DieColorG = OnChangeEditText(die_g_edit, new_text, 1, 0);
	UpdateDieColorRect();
func _on_die_b_edit_text_changed(new_text):
	GameVariable.DieColorB = OnChangeEditText(die_b_edit, new_text, 1, 0);
	UpdateDieColorRect();
################################################################################
# Rules
@onready var growth_time_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/GrowthTime/GrowthTimeEdit
@onready var apoptosis_time_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/ApoptosisTime/ApoptosisTimeEdit
@onready var calc_interval_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/CalcInterval/CalcIntervalEdit
func _on_growth_time_edit_text_changed(new_text):
	var value:float = OnChangeEditText(growth_time_edit, new_text, 10, 0);
	MatrixVariable.InitCellGrowValue(value);
func _on_apoptosis_time_edit_text_changed(new_text):
	var value:float = OnChangeEditText(apoptosis_time_edit, new_text, 10, 0);
	MatrixVariable.InitCellDieValue(value);
func _on_calc_interval_edit_text_changed(new_text):
	var value:float = OnChangeEditText(calc_interval_edit, new_text, 10, 0);
	MatrixVariable.InitCalcIntervalsValue(value);
# Time Setup
@onready var less_live_more_die_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/CalcRule1/LessLiveMoreDieEdit
@onready var less_keep_more_live_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/CalcRule2/LessKeepMoreLiveEdit
@onready var less_die_more_keep_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/CalcRule3/LessDieMoreKeepEdit
@onready var keep_mean_item_list = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/KeepMeanItemList
func _on_less_live_more_die_edit_text_changed(new_text):
	var value:float = OnChangeEditText(less_live_more_die_edit, new_text, 8, 0);
	if MatrixVariable.InitNeighboorLessLiveMoreDieValue(value):
		AdjustRuleValueEditText();
func _on_less_keep_more_live_edit_text_changed(new_text):
	var value:float = OnChangeEditText(less_keep_more_live_edit, new_text, 8, 0);
	if MatrixVariable.InitNeighboorLessKeepMoreLiveValue(value):
		AdjustRuleValueEditText();
func _on_less_die_more_keep_edit_text_changed(new_text):
	var value:float = OnChangeEditText(less_die_more_keep_edit, new_text, 8, 0);
	if MatrixVariable.InitNeighboorLessDieMoreKeepValue(value):
		AdjustRuleValueEditText();
# Reset rule
func _on_button_reset_button_down():
	MatrixVariable.InitDefaultRules();
	AdjustRuleValueEditText();
	AdjustTimeValueEditText();
	AdjustKeepMeanItemList();
################################################################################
# Matrix Width, Matrix Length
@onready var matrix_width_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/MatrixWidth/MatrixWidthEdit
@onready var matrix_length_edit = $HBoxContainer/ScrollContainer/ColorRect/VBoxContainer/MatrixLength/MatrixLengthEdit

func _on_matrix_width_edit_text_changed(new_text):
	var value:int = OnChangeEditIntVarText(matrix_width_edit, new_text, MatrixVariable.MAX_MATRIX_WIDTH, 0);
	if value > 0:
		view_manager.InitGame(value, MatrixVariable.MatrixLength);
func _on_matrix_length_edit_text_changed(new_text):
	var value:int = OnChangeEditIntVarText(matrix_length_edit, new_text, MatrixVariable.MAX_MATRIX_LENGTH, 0);
	if value > 0:
		view_manager.InitGame(MatrixVariable.MatrixWidth, value);

func _on_keep_mean_item_list_item_selected(index):
	var isKeepMeansKeepCellHp:bool = false;
	if index == 0:
		isKeepMeansKeepCellHp = true;
	MatrixVariable.SetKeepMean(isKeepMeansKeepCellHp);
