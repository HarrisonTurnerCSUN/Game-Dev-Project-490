using Godot;
using System;

public partial class OptionsMenu : Control
{
	  // Called when the Back button is pressed
	private void Back()
	{
		GetTree().ChangeSceneToFile("res://main menu/menu.tscn");
		SaveController.saveGame();
	}
}
