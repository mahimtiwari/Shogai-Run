extends Label

@export var jp_text:="最後まで進め！"
@export var jp_font: Font = null
@export var jp_font_size: int
@export var jp_pos_y_offset: int


@export var en_text:="REACH THE END!"
@export var en_font: Font = null
@export var en_font_size: int

var cLangJP := false

func _process(delta: float) -> void:
	if GameLevelManager.lang=="JP" and !cLangJP:
		text=jp_text
		cLangJP=true
		add_theme_font_override("font", jp_font)
		add_theme_font_size_override("font_size", jp_font_size)
		position.y-=jp_pos_y_offset
	elif GameLevelManager.lang=="EN" and cLangJP:
		text=en_text
		cLangJP=false
		add_theme_font_override("font", en_font)
		add_theme_font_size_override("font_size", en_font_size)
		position.y+=jp_pos_y_offset
