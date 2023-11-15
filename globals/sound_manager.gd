extends Node

const MAX_PLAYERS = 16
const AUDIO_BUS = "master"

# Player Pool
var pool : Array[AudioStreamPlayer]
var queue : Array[AudioStream]

# Interruptable players
var voice_player : AudioStreamPlayer

# TODO: dynamically do this please please please
const Sounds : Dictionary = {
	"baseball_hit": preload("res://assets/audio/sfx/se_baseball_hit.ogg"),
	"dash": preload("res://assets/audio/sfx/se_dash.ogg"),
	"death": preload("res://assets/audio/sfx/se_death.ogg"),
	"hit": preload("res://assets/audio/sfx/se_hit.ogg"),
	"jab": preload("res://assets/audio/sfx/se_jab.ogg"),
	"jump": preload("res://assets/audio/sfx/se_jump.ogg"),
	"land": preload("res://assets/audio/sfx/se_land.ogg"),
	"land_light": preload("res://assets/audio/sfx/se_land_light.ogg"),
	"laurel": preload("res://assets/audio/sfx/se_laurel.ogg"),
	"menu_cursor": preload("res://assets/audio/sfx/se_menu_cursor.ogg"),
	"menu_play": preload("res://assets/audio/sfx/se_menu_play.ogg"),
	"menu_select": preload("res://assets/audio/sfx/se_menu_select.ogg"),
	"ough": preload("res://assets/audio/sfx/se_ough.ogg"),
	"punch": preload("res://assets/audio/sfx/se_punch.ogg"),
	"shoot": preload("res://assets/audio/sfx/se_shoot.ogg"),
	"squeak": preload("res://assets/audio/sfx/se_squeak.ogg"),
	"talk": preload("res://assets/audio/sfx/se_talk.ogg"),
	"target_break": preload("res://assets/audio/sfx/se_target_break.ogg"),
	"target_hit": preload("res://assets/audio/sfx/se_target_hit.ogg"),
	"textbox_default": preload("res://assets/audio/sfx/se_textbox_default.ogg"),
	"thing": preload("res://assets/audio/sfx/se_thing.ogg"),
	"very_bad": preload("res://assets/audio/sfx/se_very_bad.ogg"),
	"voice_0": preload("res://assets/audio/sfx/se_voice_0.ogg"),
	"voice_1": preload("res://assets/audio/sfx/se_voice_1.ogg"),
	"voice_2": preload("res://assets/audio/sfx/se_voice_2.ogg"),
	"voice_3": preload("res://assets/audio/sfx/se_voice_3.ogg"),
	"voice_4.1": preload("res://assets/audio/sfx/se_voice_4.1.ogg"),
	"voice_4.2": preload("res://assets/audio/sfx/se_voice_4.2.ogg"),
	"voice_4.3": preload("res://assets/audio/sfx/se_voice_4.3.ogg"),
	"voice_4": preload("res://assets/audio/sfx/se_voice_4.ogg"),
	"voice_4_4": preload("res://assets/audio/sfx/se_voice_4_4.ogg"),
	"voice_4_5": preload("res://assets/audio/sfx/se_voice_4_5.ogg"),
	"voice_laurel": preload("res://assets/audio/sfx/se_voice_laurel.ogg"),
	"voice_ough2": preload("res://assets/audio/sfx/se_voice_ough2.ogg"),
	"voice_ough": preload("res://assets/audio/sfx/se_voice_ough.ogg"),
	"voice_sans": preload("res://assets/audio/sfx/se_voice_sans.ogg"),
	"wao": preload("res://assets/audio/sfx/se_wao.ogg"),
}

func _ready():
	for i in MAX_PLAYERS:
		var p = AudioStreamPlayer.new()
		add_child(p)
		pool.push_back(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = AUDIO_BUS
	
	voice_player = AudioStreamPlayer.new()
	add_child(voice_player)
	voice_player.bus = AUDIO_BUS

func _on_stream_finished(stream):
	pool.push_back(stream)

func play_se(sound_effect : String, from_position : float = 0.0) -> void:
	if sound_effect != "" and sound_effect != null:
		self.play_deferred("SE", sound_effect, from_position)
	else:
		print("sound [", sound_effect, "] does not exist!")

func play_vc(sound_effect : String, from_position : float = 0.0) -> void:
	if sound_effect != "" and sound_effect != null:
		self.play("SE", sound_effect, from_position, voice_player)
	else:
		print("sound [", sound_effect, "] does not exist!")

func play_deferred(sound_type : String, sound_effect : String, from_position : float = 0.0) -> void:
	call_deferred("play", sound_type, sound_effect, from_position)

func get_player() -> AudioStreamPlayer:
	if pool.is_empty():
		return null
	return pool.pop_back()

func play(_sound_type : String, sound_effect : String, from_position : float, player := get_player()) -> void:
	if player == null:
		return
	
	var stream : AudioStream = Sounds.get(sound_effect)
	
	if stream == null:
		print("could not load sound [", sound_effect, "]")
		return
	
	player.stream = stream
	player.play(from_position)

