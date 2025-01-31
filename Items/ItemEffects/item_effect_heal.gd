class_name ItemEffectHeal extends ItemEffect

@export var heal_amound: int = 1
@export var audio: AudioStream

func use() -> void:
    PlayerManager.player.update_hp(heal_amound)
    PauseMenu.play_audio(audio)

