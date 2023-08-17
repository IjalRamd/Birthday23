@tool
extends MarginContainer

var _text: String
@export var text: String:
	get:
		return _text
	set(value):
		_text = value
		if $HBoxContainer/Label:
			$HBoxContainer/Label.text = value

var _finished: bool
@export var finished: bool:
	get:
		return _finished
	set(value):
		_finished = value
		if $HBoxContainer/Finished:
			$HBoxContainer/Finished.visible = value
			$HBoxContainer/Unfinished.visible = not value

var freeing: bool = false

func _ready():
	$HBoxContainer/Label.text = text
	$HBoxContainer/Finished.visible = finished
	$HBoxContainer/Unfinished.visible = not finished

func mark_finished():
	finished = true

func show_animated():
	if $AnimationPlayer and $AnimationPlayer.has_animation("show"):
		$AnimationPlayer.play("show")
		await $AnimationPlayer.animation_finished

func hide_animated():
	if $AnimationPlayer and $AnimationPlayer.has_animation("hide"):
		$AnimationPlayer.play("hide")
		await $AnimationPlayer.animation_finished

func hide_animated_and_free():
	if freeing:
		return
	freeing = true
	await hide_animated()
	var tween = get_tree().create_tween()
	$Panel.custom_minimum_size.y = size.y
	$HBoxContainer.queue_free()
	tween.set_ease(Tween.EASE_OUT).tween_property($Panel, "custom_minimum_size:y", 0, 0.15)
	await tween.finished
	queue_free()