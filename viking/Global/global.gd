extends Node
var relics: int = 0
var earth_enemies_left: int = 0
var ice_enemies_left: int = 0
var player_health: int = 100
var mana: int = 0
var player_speed: int = 300
var bullet_speed: int = 500
var enemy_speed: int = 1.5
var xp: int = 0
var patron_god: int = 0
var has_key: bool = false
var loaded_banks = {}
var world_level: int = 1
var upgrade_level: int = 1

func reset_globals():
	relics = 0
	earth_enemies_left = 0
	ice_enemies_left = 0
	player_health = 100
	mana = 0
	player_speed = 300
	bullet_speed = 500
	enemy_speed = 1.5
	xp = 0
	patron_god = 0
	has_key = false
	world_level = 1
	upgrade_level = 1
