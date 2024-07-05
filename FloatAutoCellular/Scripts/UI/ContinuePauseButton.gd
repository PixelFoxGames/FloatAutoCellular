extends Button

const RUN = preload("res://Sources/UI/Run.png")
const PAUSE = preload("res://Sources/UI/Pause.png")

func _on_button_down():
	SwitchRunPauseMode();

func SwitchRunPauseMode() -> void:
	GameVariable.ChangeRunPauseMode(not GameVariable.IsPlaying);
	if GameVariable.IsPlaying == true:
		icon = PAUSE;
	else:
		icon = RUN;
