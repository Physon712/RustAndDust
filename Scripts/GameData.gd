extends Node

### INPUT SETTINGS
var mouse_sensivity = 0.005;

### CONST
const armor_type_light = 0
const armor_type_heavy = 1
const armor_type_kevlar = 2
const armor_type_reactive = 3
const armor_type_magshield = 4

const damage_type_pistol = 0
const damage_type_intermediate = 1
const damage_type_rifle = 2
const damage_type_antimaterial = 3
const damage_type_explosive = 4
const damage_type_kinetic = 5

const part_type_core = 0
const part_type_bipedleg = 1
const part_type_arm = 2


### Game Rules
const damage_multiplicator =[
	[1,1,1,1,1,1], #LIGHT
	[0.5,0.7,0.8,1,0.5,0.7], #HEAVY
	[0.2,0.4,0.6,1,1,1], #KEVLAR
	[0.8,0.8,0.8,0.8,0.2,0.2], #REACTIVE
	[1,1,1,1,2,1] #MAGNETIC SHIELDING
]
