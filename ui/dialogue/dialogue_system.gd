class_name DialogueSystem

extends Control

@onready var _title := $Textboxes/TextBox/Title
@onready var _content := $Textboxes/TextBox/Content
@onready var _parser := $Textboxes/TextBox/Parser
@onready var _sprite := $Textboxes/TalkBox/Sprite

var curr_voice : String

var text = []
var index = -1

var effects = []

var _wait_time = 0

# chars/second
const rate = 30

var _timer = 0
var _last_len = -1

func add_content(txt : String):
	_parser.bbcode_text = txt
	var p_txt = _parser.text
	var l = txt.find('{')
	var r = -1
	var off = p_txt.find('{') - l
	var fx = {}
	while l >= 0:
		off = p_txt.find('{', l + off)
		l = txt.find('{', l)
		off = off - l
		
		if l > 0 and txt[l-1] == '\\':
			continue
		elif l >= 0:
			r = txt.find('}', l)
			if r >= 0:
				var args = txt.substr(l+1, r-l-1)
				if fx.has(l + off):
					fx[l + off].append(args)
				else: 
					fx[l + off] = [args]
				#print("%d: %s" % [l + off, fx[l + off]])
				txt = txt.substr(0, l) + txt.substr(r+1)
				p_txt = p_txt.substr(0, l + off) + p_txt.substr(r+1 + off)
	
	text.append(txt)
	effects.append(fx)

func set_content(content : String):
	_content.bbcode_text = content

func set_title(title : String):
	_title.bbcode_text = title

func play_effect(effect : String):
	var args = effect.split(' ')
	match args[0]:
		'wait':
			_wait_time = 0#args[1]
		'title':
			set_title(args[1])
		'voice':
			set_voice(args[1])
		'sprite':
			set_sprite(args[1])

func set_voice(voice : String):
	var v = "voice_" + voice
	if SoundManager.Sounds.has(v):
		curr_voice = v
	else:
		curr_voice = "voice_0"

func set_sprite(animation: String):
	match animation:
		"virus", "memo_neutral", "funny":
			_sprite.play(animation)
		_:
			_sprite.play("memo_neutral")

func advance_text():
	_content.visible_ratio = 0
	_timer = 0
	_wait_time = 0
	_last_len =  -1
	index += 1
	if index == text.size():
		end_playback()
	else:
		set_content(text[index])

func complete_text():
	for i in range(floor(_timer), _content.text.length()):
		if effects[index].has(i):
			for e in effects[index][i]:
				play_effect(e)
	_wait_time = 0	
	_timer = _content.text.length()

func end_playback():
	queue_free()

func _process(delta):
	var msg_len = _content.text.length()
	var vis_len = _content.visible_characters
	if vis_len < msg_len:
		if _last_len < vis_len:
			if effects[index].has(vis_len):
				for e in effects[index][vis_len]:
					play_effect(e)
			var curr_char = _content.text[vis_len]
			match curr_char:
				' ','\'','"':
					pass
				'.','!','?',',':
					_wait_time = 0.05
				_:
					if _wait_time <= 0:
						SoundManager.play_vc(curr_voice)
		
		if _wait_time > 0:
			_wait_time -= delta
			_sprite.frame = 0
			_sprite.stop()
		else:
			_timer += delta * rate
			_content.visible_characters = min(msg_len, floor(_timer))
			_sprite.play()
	else:
		_sprite.stop()
		_sprite.frame = 0
	_last_len = vis_len

func _input(event):
	if event.is_action_pressed("act"):
		if _content.visible_characters < _content.text.length():
			complete_text()
		else:
			advance_text()
