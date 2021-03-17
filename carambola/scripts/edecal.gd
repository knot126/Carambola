extends Node

class_name EDecal

# Sub-components
const _Properties = ["editor_name", "position", "decal", "size", "colourise", "colour"]
var _box : MeshInstance = null
var timeSinceLastPhysicsUpdate : float = 0.0

# Elements
var editor_name : String = "Decal" + str(randi() % 1000)
var size : Vector2 = Vector2(1.0, 1.0)
var position : Vector3 = Vector3()
var decal : int = 0
var colourise : bool = false
var colour : Color = Color(0.5, 0.5, 0.5, 1.0)

func _ready():
	globals.selection = self

func _physics_process(delta):
	timeSinceLastPhysicsUpdate += delta
	if (timeSinceLastPhysicsUpdate > 0.1):
		updateThis()
		timeSinceLastPhysicsUpdate = 0.0

func updateThis():
	if (_box):
		_box.free()
	
	_box = MeshInstance.new()
	_box.translation = position
	_box.mesh = QuadMesh.new()
	_box.mesh.size = Vector2(size.x * 2.0, size.y * 2.0)
	
	var mat = SpatialMaterial.new()
	if (colourise):
		mat.albedo_color = colour
	mat.albedo_texture = globals.get_decal(decal)
	mat.flags_transparent = true
	_box.set_surface_material(0, mat)
	
	var _col = ClickableStaticBody.new()
	var box = BoxShape.new()
	box.set_extents(Vector3(size.x, size.y, 0.0))
	var shape = _col.create_shape_owner(box)
	_col.shape_owner_add_shape(shape, box)
	_box.add_child(_col)
	
	self.add_child(_box)

func set_active():
	globals.selection = self

func asXMLElement():
	var s = "<decal " 
	s += "pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
	s += "size=\"" + str(size.x) + " " + str(size.y) + "\" "
	s += "tile=\"" + str(decal) + "\" "
	if (colourise):
		var cstr = ""
		cstr += str(colour.r) + " " + str(colour.g) + " " + str(colour.b)
		if (colour.a < 1.0):
			cstr += " " + str(colour.a)
		s += "color=\"" + cstr + "\" "
	s += "/>"
	
	return s