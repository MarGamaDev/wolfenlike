extends Control

var tutorial_page_amount : int  = 3
var currently_viewed_page : int = 0

@onready var menu_page : Control = $MenuPage
@onready var credits_page : Control = $CreditsPage
@onready var tutorial_page : Control = $TutorialPage

@onready var tutorial_subpages : Array[Control] = [$TutorialPage/ColorRect/TutorialStep1,
$TutorialPage/ColorRect/TutorialStep2, $TutorialPage/ColorRect/TutorialStep3]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_start_button_pressed() -> void:
	##REPLACE THIS WITH MAIN SCENE ONCE WE HAVE IT
	get_tree().change_scene_to_file("res://Player/player test/player_test.tscn")
	pass # Replace with function body.


func _on_tutorial_button_pressed() -> void:
	menu_page.hide()
	tutorial_page.show()
	currently_viewed_page = 0
	for page in tutorial_subpages:
		page.hide()
	$TutorialPage/NextPageButton.show()
	$TutorialPage/LastPageButton.hide()
	$TutorialPage/StartGameButton.hide()
	tutorial_subpages[currently_viewed_page].show()
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	menu_page.hide()
	credits_page.show()
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_return_to_menu_button_pressed() -> void:
	credits_page.hide()
	tutorial_page.hide()
	menu_page.show()
	pass # Replace with function body.


func _on_tutorial_next_page_button_pressed() -> void:
	$TutorialPage/NextPageButton.show()
	$TutorialPage/LastPageButton.show()
	$TutorialPage/StartGameButton.hide()
	if currently_viewed_page < tutorial_subpages.size():
		tutorial_subpages[currently_viewed_page].hide()
		currently_viewed_page += 1
		tutorial_subpages[currently_viewed_page].show()
		if currently_viewed_page == tutorial_subpages.size() - 1:
			$TutorialPage/NextPageButton.hide()
			$TutorialPage/StartGameButton.show()

func _on_tutorial_last_page_button_pressed() -> void:
	$TutorialPage/NextPageButton.show()
	$TutorialPage/LastPageButton.show()
	$TutorialPage/StartGameButton.hide()
	if currently_viewed_page > 0:
		tutorial_subpages[currently_viewed_page].hide()
		currently_viewed_page -= 1
		tutorial_subpages[currently_viewed_page].show()
		if currently_viewed_page == 0:
			$TutorialPage/LastPageButton.hide()
