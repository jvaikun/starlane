extends Resource
class_name MissionGen

const FIRST_NAMES = ["Abandoned","Absolute","Abyssal","Alien","Ancient","Angry","Awful","Bad","Barbarous",
"Bare","Bared","Bedazzled","Beginner's","Bestial","Big","Bitter","Black","Bleak",
"Bloodstained","Bloody","Blue","Blunt","Bold","Brave","Bright","Brisk","Broken",
"Bronze","Brutal","Buried","Burning","Calm","Carnal","Carnivorous","Cimmerian","Clean",
"Clouded","Cold","Colossal","Compact","Corroded","Corrosive","Corrupt","Covered","Covetous",
"Coward's","Crazy","Creeping","Crimson","Cruel","Crumbling","Crumbly","Crying","Dark",
"Darkest","Dastardly","Dead","Deadly","Dead Man's","Decayed","Deep","Defect","Desperate",
"Devil's","Dim","Dirty","Distant","Divine","Dreadful","Dry","Duplicitous",
"Dusty","Emerald","Empty","Endless","Eternal","Everlasting","Evil","Exposed",
"Fast","Fathomless","Fearful","Fearless","Feral","Fierce","Final","First","Foggy",
"Fool's","Forbidden","Forgotten","Forsaken","Foul","Fractured","Fragile","Freak","Frightened",
"Frozen","Full","Furious","Gangrenous","Gargantuan","Giant","Glowing","Great","Green",
"Gunner's","Gutless","Hard","Heavy","Hermit's","Hidden","Hideous","High","Hunter's",
"Illuminated","Imperfect","Impure","Infernal","Infested","Infinity","Insane","Irrational","Jagged",
"Jealous","Last","Loaded","Loser's","Loud","Low","Lucky",
"Mad","Mad Man's","Mammoth","Massive","Meek","Mighty","Mild","Morning","Murderous",
"Murky","Mythic","Naked","Natural","Noble","Old","Open","Outrageous","Pale",
"Peeled","Petrified","Pure","Purified","Raging","Rancid","Ranger's","Rapid","Raw",
"Red","Rejected","Rippled","Rocky","Rotten","Rough","Ruptured","Sacred","Sad",
"Scarred","Scout's","Second","Secret","Secure","Shallow","Sharp","Shattered","Shining",
"Silent","Snowy","Solid","Solitary","Spiked","Spineless","Stale","Stinking","Stony",
"Strange","Sudden","Sunken","Tainted","Titanic","Total","True","Uncovered","Unhealthy",
"Unknown","Unrobed","Unveiled","Useless","Warrior's","Weak","Weeping","White",
"Wicked","Wide","Wild","Worthy","Xeno","Yellow"]

const LAST_NAMES = ["Abyss","Agony","Anvil","Arm","Armpit","Avalanche","Axe","Badland","Barrens",
"Base","Basin","Bed","Bedrock","Belly","Benefit","Betrayal","Blackness","Blackout",
"Blade","Blank","Bluff","Bones","Boneyard","Border","Bottom","Breach","Break",
"Breeze","Burrow","Cap","Carcass","Carve","Catacomb","Catch","Caves","Cavity",
"Ceiling","Cell","Cellar","Cemetery","Chamber","Chance","Chasm","Citadel","Claw",
"Clearance","Clearing","Comeback","Contact","Core","Cover","Covert","Crater","Crib",
"Crosscut","Crown","Crypt","Darkness","Dawn","Death","Decay","Delight","Den",
"Depths","Derail","Descent","Desert","Digs","Ditch","Dome","Doom","Downfall",
"Dream","Drift","Drop","Dump","Dusk","Earth","Echo","Eclipse","Edge",
"Elevation","Enclosure","End","Expanse","Face","Fangs","Fear","Feast","Fence",
"Field","Find","Fissure","Foot","Force","Fort","Fury","Gap","Gate",
"Ghost","Gods","Goods","Gorge","Grave","Grin","Grotto","Ground","Guts",
"Habitat","Hammer","Hand","Hate","Haunt","Head","Heart","Helix","Hell",
"Hideout","Hold","Hole","Hollow","Honor","Hook","Hope","Hulrum","Hunt",
"Ideal","Impact","Inferno","Inland","Interest","Jewel","Joy","Keep","Key",
"Killing","Lair","Land","Ledge","Legacy","Let-down","Level","Leverage","Lodge",
"Look","Luck","Madness","Memorial","Mork","Mouth","Needle","Nest","Night",
"Nightfall","Nightmare","Oddness","Outback","Outpost","Overhang","Overlook","Palace","Pass",
"Passage","Path3D","Patrol","Pearl","Perfection","Pit","Pitfall","Plateau","Pocket",
"Point","Position","Prize","Pursuit","Rage","Raid","Ravine","Relief","Reserve",
"Retreat","Return","Rising","Risk","Rock","Roof","Run","Sadness","Salute",
"Sanctuary","Scream","Senit","Shaft","Shelf","Shelter","Shock","Shroud","Skull",
"Sleep","Slope","Soil","Sorrow","Split","Strike","Summit","Territory","Thickening",
"Thunder","Tomb","Tongue","Track","Trail","Trench","Trick","Unfortune","Valley",
"Vault","View","Void","Walk","Wasteland","Wealth","Well","Wilderness","Womb",
"Wrath","Wreck"]

const BACKGROUNDS = ["res://ui/background/512blue01.png", "res://ui/background/512blue02.png", 
"res://ui/background/512blue03.png", "res://ui/background/512blue04.png", 
"res://ui/background/512blue05.png", "res://ui/background/512blue06.png", 
"res://ui/background/512blue07.png", "res://ui/background/512blue08.png"]

const double_sine = {
	"pattern":[
		{
			"position": Vector2(0.1, 0),
			"move": "move_sine",
			"speed": 150,
			"time_scale": TAU,
			"flip_h": false,
			"delay": 0,
		},
		{
			"position": Vector2(0.9, 0),
			"move": "move_sine",
			"speed": 150,
			"time_scale": TAU,
			"flip_h": true,
			"delay": 0,
		},
	],
	"repeat_range": [4, 6],
	"repeat_delay": 0.25,
}

const double_zigzag = {
	"pattern":[
		{
			"position": Vector2(0.4, 0),
			"move": "move_zigzag",
			"speed": 300,
			"time_scale": 2,
			"flip_h": false,
			"delay": 0,
		},
		{
			"position": Vector2(0.6, 0),
			"move": "move_zigzag",
			"speed": 300,
			"time_scale": 2,
			"flip_h": true,
			"delay": 0,
		},
	],
	"repeat_range": [4, 6],
	"repeat_delay": 0.25,
}

const double_swoop = {
	"pattern":[
		{
			"position": Vector2(0.2, 0),
			"move": "move_dive",
			"speed": 150,
			"time_scale": 2,
			"flip_h": true,
			"delay": 0,
		},
		{
			"position": Vector2(0.8, 0),
			"move": "move_dive",
			"speed": 150,
			"time_scale": 2,
			"flip_h": false,
			"delay": 0,
		},
	],
	"repeat_range": [4, 6],
	"repeat_delay": 0.25,
}

const wedge = {
	"pattern":[
		{
			"position": Vector2(0.5, 0),
			"move": "move_down",
			"speed": 150,
			"time_scale": 2,
			"flip_h": false,
			"delay": 0.25,
		},
		{
			"position": Vector2(0.4, 0),
			"move": "move_down",
			"speed": 150,
			"time_scale": 2,
			"flip_h": false,
			"delay": 0,
		},
		{
			"position": Vector2(0.6, 0),
			"move": "move_down",
			"speed": 150,
			"time_scale": 2,
			"flip_h": false,
			"delay": 0.25,
		},
		{
			"position": Vector2(0.3, 0),
			"move": "move_down",
			"speed": 150,
			"time_scale": 2,
			"flip_h": false,
			"delay": 0,
		},
		{
			"position": Vector2(0.7, 0),
			"move": "move_down",
			"speed": 150,
			"time_scale": 2,
			"flip_h": false,
			"delay": 0,
		},
	],
	"repeat_range": [1, 1],
	"repeat_delay": 0.5,
}

const wedge_swoop = {
	"pattern":[
		{
			"position": Vector2(0.5, 0),
			"move": "move_down",
			"speed": 150,
			"time_scale": 2,
			"flip_h": false,
			"delay": 0.25,
		},
		{
			"position": Vector2(0.4, 0),
			"move": "move_dive",
			"speed": 150,
			"time_scale": 2,
			"flip_h": true,
			"delay": 0,
		},
		{
			"position": Vector2(0.6, 0),
			"move": "move_dive",
			"speed": 150,
			"time_scale": 2,
			"flip_h": false,
			"delay": 0.25,
		},
		{
			"position": Vector2(0.3, 0),
			"move": "move_dive",
			"speed": 150,
			"time_scale": 2,
			"flip_h": false,
			"delay": 0,
		},
		{
			"position": Vector2(0.7, 0),
			"move": "move_dive",
			"speed": 150,
			"time_scale": 2,
			"flip_h": true,
			"delay": 0,
		},
	],
	"repeat_range": [1, 1],
	"repeat_delay": 0.5,
}

const SPAWNS = [
	double_sine,
	double_swoop,
	double_zigzag,
	wedge,
	wedge_swoop,
]
const BOSSES = [preload("res://bosses/enemy_boss.tscn")]


func generate_name():
	return FIRST_NAMES.pick_random() + " " + LAST_NAMES.pick_random()


func generate_mission(wave_list):
	var new_mission = Mission.new()
	new_mission.name = generate_name()
	new_mission.background = BACKGROUNDS.pick_random()
	for wave in wave_list:
		new_mission.map_points.append(wave.coords)
		var my_wave = SPAWNS.pick_random()
		var my_size = 1
		my_size = randi_range(my_wave.repeat_range[0], my_wave.repeat_range[1])
		new_mission.waves.append({
			"size": my_size,
			"spawn": my_wave, 
			"next": 1 + randi() % 2
		})
	new_mission.boss = BOSSES[0]
	return new_mission

