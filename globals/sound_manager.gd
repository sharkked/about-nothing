extends Node

const MAX_SFX_PLAYERS = 16
const AUDIO_BUS = "master"

enum SoundType {
	BGM,
	BGM_LOOP,
	SFX,
	VC,
}

# BGM player
var bgm_player: AudioStreamPlayer

# SFX Player pool
var pool: Array[AudioStreamPlayer]
var queue: Array[AudioStream]

# Interruptable players
var voice_player: AudioStreamPlayer

# TODO: dynamically do this please please please
const _bgm: Dictionary = {
	"dogvirus": preload("res://assets/audio/bgm/bgm_dogvirus.ogg"),
	"dogvirus_chill": preload("res://assets/audio/bgm/bgm_dogvirus_chill.ogg"),
	"spaz": preload("res://assets/audio/bgm/bgm_spaz.ogg"),
	"test": preload("res://assets/audio/bgm/bgm_test.ogg"),
	"test2": preload("res://assets/audio/bgm/bgm_test2.ogg"),
}

const _sfx: Dictionary = {
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
	"wao": preload("res://assets/audio/sfx/se_wao.ogg"),
}

const _vc: Dictionary = {
	"0": preload("res://assets/audio/vc/vc_0.ogg"),
	"1": preload("res://assets/audio/vc/vc_1.ogg"),
	"2": preload("res://assets/audio/vc/vc_2.ogg"),
	"3": preload("res://assets/audio/vc/vc_3.ogg"),
	"4.1": preload("res://assets/audio/vc/vc_4.1.ogg"),
	"4.2": preload("res://assets/audio/vc/vc_4.2.ogg"),
	"4.3": preload("res://assets/audio/vc/vc_4.3.ogg"),
	"4": preload("res://assets/audio/vc/vc_4.ogg"),
	"4_4": preload("res://assets/audio/vc/vc_4_4.ogg"),
	"4_5": preload("res://assets/audio/vc/vc_4_5.ogg"),
	"laurel": preload("res://assets/audio/vc/vc_laurel.ogg"),
	"ough2": preload("res://assets/audio/vc/vc_ough2.ogg"),
	"ough": preload("res://assets/audio/vc/vc_ough.ogg"),
	"sans": preload("res://assets/audio/vc/vc_sans.ogg"),
}

func _ready():
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "BGM"
	add_child(bgm_player)

	for i in MAX_SFX_PLAYERS:
		var p = AudioStreamPlayer.new()
		pool.push_back(p)
		p.bus = "SFX"
		p.finished.connect(_on_stream_finished.bind(p))
		add_child(p)

	voice_player = AudioStreamPlayer.new()
	voice_player.bus = "VC"
	add_child(voice_player)


func _on_stream_finished(stream):
	pool.push_back(stream)

func has_sound(sound_type: SoundType, sound_name: String) -> bool:
	if !sound_name:
		return false
	match sound_type:
		SoundType.BGM:
			return _bgm.has(sound_name)
		SoundType.SFX:
			return _sfx.has(sound_name)
		SoundType.VC:
			return _vc.has(sound_name)
	return false

func play_bgm(bgm_name: String, from_position: float = 0.0) -> void:
	if has_sound(SoundType.BGM, bgm_name):
		self.play(SoundType.BGM, bgm_name, from_position, bgm_player)
	else:
		print("bgm [", bgm_name, "] does not exist!")

func play_se(sound_name: String, from_position: float = 0.0) -> void:
	if has_sound(SoundType.SFX, sound_name):
		self.play_deferred(SoundType.SFX, sound_name, from_position)
	else:
		print("sound [", sound_name, "] does not exist!")


func play_vc(sound_name: String, from_position: float = 0.0) -> void:
	if has_sound(SoundType.VC, sound_name):
		self.play(SoundType.VC, sound_name, from_position, voice_player)
	else:
		print("vc [", sound_name, "] does not exist!")


func play_deferred(sound_type: SoundType, sound_name: String, from_position: float = 0.0) -> void:
	call_deferred("play", sound_type, sound_name, from_position)


func get_player() -> AudioStreamPlayer:
	if pool.is_empty():
		return null
	return pool.pop_back()


func play(
	sound_type: SoundType, sound_name: String, from_position: float, player := get_player()
) -> void:
	if player == null:
		return

	var stream: AudioStream

	match sound_type:
		SoundType.BGM:
			stream = _bgm.get(sound_name)
		SoundType.SFX:
			stream = _sfx.get(sound_name)
		SoundType.VC:
			stream = _vc.get(sound_name)

	if stream == null:
		print("could not load sound [", sound_name, "]")
		return

	player.stream = stream
	player.play(from_position)
