extends Control

signal next()

@onready var time: Label = $EntireStatsBox/Columns/NumberColumn/Time
@onready var early_bumps: Label = $EntireStatsBox/Columns/NumberColumn/EarlyBumps
@onready var late_bumps: Label = $EntireStatsBox/Columns/NumberColumn/LateBumps
@onready var perfect_bumps: Label = $EntireStatsBox/Columns/NumberColumn/PerfectBumps
@onready var bounces: Label = $EntireStatsBox/Columns/NumberColumn/Bounces
@onready var score: Label = $EntireStatsBox/Columns/NumberColumn/Score
@onready var final_score = $EntireStatsBox/FinalScoreBox/FinalScore

var bump_earlylate_multiplicator: int = 500
var bump_perfect_multiplicator: int = 2000
var bounce_multiplicator: int = 10
var final_score_value:int = 0.0

func _ready() -> void:
	#$VBoxContainer/NextBtn.grab_focus()
	update_stats()
	hide_stats()
	#animate_stats() (already called on animation)

func update_stats() -> void:
	var ms = Globals.stats["time"] * 1000
	var seconds: int = int(ms / 1000 )% 60
	var minutes: int = int(ms / 1000 / 60)
	time.text = str(minutes) + ":" + str(seconds)
	early_bumps.text = str(Globals.stats["bumps_early"])
	late_bumps.text = str(Globals.stats["bumps_late"])
	perfect_bumps.text = str(Globals.stats["bumps_perfect"])
	bounces.text = str(Globals.stats["ball_bounces"])
	score.text = str(Globals.stats["score"])
	final_score.text = str((Globals.stats["bumps_early"]*bump_earlylate_multiplicator)+
		(Globals.stats["bumps_late"]*bump_earlylate_multiplicator)+
		(Globals.stats["bumps_perfect"]*bump_perfect_multiplicator)+
		(Globals.stats["ball_bounces"]*bounce_multiplicator)+
		Globals.stats["score"])
	final_score_value = ((Globals.stats["bumps_early"]*bump_earlylate_multiplicator)+
		(Globals.stats["bumps_late"]*bump_earlylate_multiplicator)+
		(Globals.stats["bumps_perfect"]*bump_perfect_multiplicator)+
		(Globals.stats["ball_bounces"]*bounce_multiplicator)+
		Globals.stats["score"])

func hide_stats()->void:
	for child in $EntireStatsBox/Columns/NameColumn.get_children():
		child.self_modulate.a = 0.0
	for child in $EntireStatsBox/Columns/NumberColumn.get_children():
		child.self_modulate.a = 0.0
	$EntireStatsBox/FinalScoreBox/Label.self_modulate.a = 0.0
	final_score.self_modulate.a = 0.0
	#$ButtomContainer.self_modulate.a = 0.0
	$ButtomContainer/NextBtn.self_modulate.a = 0.0
func animate_stats()->void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for child in $EntireStatsBox/Columns/NameColumn.get_children():
		tween.tween_property(child,"position:x",0.0,0.25).from(-get_viewport_rect().size.x)
		tween.parallel().tween_property(child,"self_modulate:a", 1.0,0.25)
	
	for i in range($EntireStatsBox/Columns/NumberColumn.get_child_count()):
		var child = $EntireStatsBox/Columns/NumberColumn.get_child(i)
		var key = Globals.stats.keys()[i]
		tween.tween_method(set_label_number.bind(child),0,Globals.stats[key],0.5)
		tween.parallel().tween_property(child,"self_modulate:a", 1.0,0.25)
		tween.parallel().tween_callback(screen_shake.bind(0.4,20,10))
		tween.parallel().tween_callback($Shaker.start.bind(0.25))
		tween.tween_interval(0.26)
	
	tween.tween_interval(0.25)
	
	#MOVE FINAL SCORE LABEL LEFT TO RIGHT
	tween.tween_property($EntireStatsBox/FinalScoreBox/Label,"position:x",0.0,0.3).from(-get_viewport_rect().size.x)
	tween.parallel().tween_property($EntireStatsBox/FinalScoreBox/Label,"self_modulate:a", 1.0,0.25)
	#FINAL SCORE COUNT UP
	tween.tween_method(set_label_number.bind(final_score),0,final_score_value,0.5)
	tween.parallel().tween_property(final_score,"self_modulate:a", 1.0,0.25)
	tween.parallel().tween_callback(screen_shake.bind(0.4,20,10))
	tween.parallel().tween_callback($Shaker.start.bind(1.0))
	
	tween.tween_interval(1.0)
	tween.tween_property($ButtomContainer,"position:y",904,0.3).from(get_viewport_rect().size.y)
	tween.parallel().tween_property($ButtomContainer/NextBtn,"self_modulate:a", 1,0.3).from(0.0)
	tween.tween_callback($ButtomContainer/NextBtn.grab_focus)
	

func set_label_number(number:int, label:Label) -> void:
	label.set_text(str(number))

func screen_shake(duration: float, frequency: float, amplitude: float):
	#Globals.camera.shake(duration,frequency,amplitude)
	pass

func _on_NextBtn_pressed() -> void:
	emit_signal("next")
	queue_free()
