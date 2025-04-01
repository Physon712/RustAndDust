extends Node

### PLAYER SETTINGS
var mouse_sensivity = 0.005;
var third_person = false;

### GAME VARIABLE
var in_menu = false

### GAME CONST
const GRAVITY = -9.8 

const ARMOR_TYPE_LIGHT = 0
const ARMOR_TYPE_HEAVY = 1
const ARMOR_TYPE_KEVLAR = 2
const ARMOR_TYPE_REACTIVE = 3
const ARMOR_TYPE_MAGSHIELD = 4

const DAMAGE_TYPE_PISTOL = 0
const DAMAGE_TYPE_INTERMEDIATE = 1
const DAMAGE_TYPE_RIFLE = 2
const DAMAGE_TYPE_ANTIMATERIAL = 3
const DAMAGE_TYPE_EXPLOSIVE = 4
const DAMAGE_TYPE_KINETIC = 5

const PART_TYPE_CORE = 0
const PART_TYPE_LEG = 1
const PART_TYPE_ARM = 2
const PART_TYPE_QUADLEGS = 3

const MOBILITY_TYPE_LEG = 0
const MOBILITY_TYPE_QUADLEGS = 1
const MOBILITY_TYPE_WHEEL = 2

enum PartType {CORE,MOVEMENT,HEAD,LEG,ARM,HANDTOOL,BRAIN}
enum Faction {NEUTRAL,LONER,PLAYER,SCRAPER}
const part_type_name = ["Core","Movement module","Head","Leg","Arm","Hand tool","AI Chip"]
### Game Rules
const damage_multiplicator =[
	[1,1,1,1,1,1], #LIGHT
	[0.5,0.7,0.8,1,0.5,0.7], #HEAVY
	[0.2,0.4,0.6,1,1,1], #KEVLAR
	[0.8,0.8,0.8,0.8,0.2,0.2], #REACTIVE
	[1,1,1,1,2,1] #MAGNETIC SHIELDING
]

func enter_menu_mode():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	in_menu = true
	
func exit_menu_mode():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	in_menu = false
