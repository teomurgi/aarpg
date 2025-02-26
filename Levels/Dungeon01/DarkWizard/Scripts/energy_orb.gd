class_name EnergyOrb extends Node2D

@export var speed: float = 200.0
@export var shoot_audio: AudioStream
@export var hit_audio: AudioStream

var direction: Vector2 = Vector2.DOWN

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
    hurtbox.did_damage.connect(hit_player)
    play_audio(shoot_audio)
    get_tree().create_timer(5.0).timeout.connect(destroy)
    direction = global_position.direction_to(PlayerManager.player.global_position)
    flicker()

func _process(delta: float) -> void:
    position += direction * speed * delta

func flicker() -> void:
    modulate.a = randf() * 0.7 + 0.3
    await get_tree().create_timer(0.05).timeout
    flicker()

func hit_player() -> void:
    hurtbox.set_deferred("monitoring", false)
    play_audio(hit_audio)

func play_audio(a: AudioStream) -> void:
    audio.stream = a
    audio.play()

func destroy() -> void:
    queue_free()