extends Control

@onready var progress: ProgressBar = $EnergyBar
@onready var gpu_particles = $EnergyBar/GPUParticles2D
@onready var shaker = $EnergyBar/Shaker

func _ready() -> void:
	progress.value = 0.0
	gpu_particles.amount = 1
	progress.rotation = 0.0
	

func set_energy(new_value: int) -> void:
	if new_value > 90.0 and new_value > progress.value:
		shaker.start()
	elif new_value < 90.0:
		shaker.stop()
		
	
	progress.value = new_value
	gpu_particles.amount = lerp(1,300,new_value/100)
