extends Sprite

var menu_off:= false
var alpha := 1.0

func _ready():
	pass

func _process(delta: float) -> void:
	if menu_off && alpha >0.0:
		alpha -= 0.01
		self.modulate.a = alpha
	elif not menu_off && alpha < 1.0:
		alpha += 0.01
		self.modulate.a = alpha
	
	if GameManager.secrets_discovered == 7:
		menu_off = false
		$VBoxContainer/Credits.tex = str(GameManager.secrets_discovered) + " Secrets Discovered"
		$VBoxContainer/Credits.visible = true
		$VBoxContainer/Credits2.visible = true
		$VBoxContainer/Button.visible = false
		$VBoxContainer/Instructions.visible = false
	
	if Input.is_action_just_pressed("ui_cancel"):
		menu_off = !menu_off
		$VBoxContainer/Credits.visible = true
		$VBoxContainer/Button.text = "CONTINUE"
		$VBoxContainer/Credits.text = str(GameManager.secrets_discovered) + " Secrets Discovered"
		#$VBoxContainer/Instructions.visible = false
		

func _on_Button_pressed() -> void:
	menu_off = true
	pass # Replace with function body.
