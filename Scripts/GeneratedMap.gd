extends Spatial

export (int) var Height = 1000
export (int) var Width = 1000

var PerlinNoise = OpenSimplexNoise.new()
var Map = Mesh.new()

func _ready():
	PerlinNoise.get_image(Height, Width)
