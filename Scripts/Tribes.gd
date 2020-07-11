extends Resource
class_name Tribes

enum {HUNTER, PREY}

export var hunter_ratio := 0.15

export var hunter_food_threshold := 3

export(Array, Color) var colors := [Color.black, Color.white]
export(Array, float) var speeds := [200.0, 200.0]
export(Array, float) var ages_mean := [4.0, 1.0]
export(Array, float) var ages_range := [0.2, 0.4]
