extends Node

export var mob_scene: PackedScene

var score: int = 0
var music_beat: int = 0

var mobs_active: bool = false

var difficulty: int = 0

func _ready():
	randomize()

func new_game(round_difficulty: int):
	difficulty = round_difficulty
	score = 0
	music_beat = 0
	$Music.play()
	$MusicBeatTimer.start()
	mobs_active = true
	
func game_over():
	# score
	mobs_active = false
	
	yield($MusicBeatTimer, "timeout")
	while (music_beat % 3 != 0):
		yield($MusicBeatTimer, "timeout")
	$Music.stop()
	$DeathSound.play()
	
	# visuals
	$HUD.show_message("Game over")
	yield(get_tree().create_timer(2*$HUD/MessageTimer.wait_time), "timeout")
	$HUD.game_restart()
	get_tree().call_group("mobs", "die")
	$Player.reset(Vector2(240, 360))
	$MusicBeatTimer.stop()

func _on_MusicBeat():
	music_beat += 1
	if (mobs_active):
		match (difficulty):
			0:
				if (music_beat % 3 == 0):
					spawn_mob()
			1:
				spawn_mob()
			_:
				pass
		
		
func spawn_mob():
	var mob_spawn_location := $MobSpawnPath/SpawnLocationFinder
	mob_spawn_location.unit_offset = randf()
	
	var mob := mob_scene.instance()
	add_child(mob)
	
	mob.position = mob_spawn_location.position
	var direction: float = mob_spawn_location.rotation + PI/2 + rand_range(-PI/4, PI/4)
	mob.rotation = direction
	
	var baseVelocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = baseVelocity.rotated(direction)
	
	mob.connect("death", self, "_on_Mob_death")
	
func _on_Mob_death(dead_mob):
	if (dead_mob.is_connected("death", self, "_on_Mob_death")):
		dead_mob.disconnect("death", self, "_on_Mob_death")
	if mobs_active:
		score += 1
		$HUD.update_score(score)
	
func refreshMobTimer():
	if !($MusicBeatTimer.is_stopped()):
		$MusicBeatTimer.stop()
		$MusicBeatTimer.start()
