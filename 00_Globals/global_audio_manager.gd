extends Node

var music_audio_player_count: int = 2
var current_music_player: int = 0
var music_players: Array[AudioStreamPlayer] = []
var music_bus_name: String = "Music"

var music_fade_duration: float = 0.5

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in music_audio_player_count:
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		audio_player.bus = music_bus_name
		music_players.append(audio_player)
		audio_player.volume_db = -40
		
func play_music(audio: AudioStream) -> void:
	if audio == music_players[current_music_player].stream:
		return

	current_music_player += 1
	if current_music_player > 1:
		current_music_player = 0

	var current_audio_player: AudioStreamPlayer = music_players[current_music_player]
	current_audio_player.stream = audio
	play_and_fade_in(current_audio_player)

	var old_audio_player = music_players[1]
	if current_music_player == 1:
		old_audio_player = music_players[0]
	fade_out_stop(old_audio_player)

func play_and_fade_in(audio_player: AudioStreamPlayer) -> void:
	audio_player.play(0)
	var tween: Tween = create_tween()
	tween.tween_property(audio_player, "volume_db", 0, music_fade_duration)

func fade_out_stop(audio_player: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(audio_player, "volume_db", -40, music_fade_duration)
	await tween.finished
	audio_player.stop()