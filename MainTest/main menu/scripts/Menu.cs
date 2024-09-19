using Godot;
using System;

public partial class Menu : Control
{
	// Called when the Play button is pressed
	private void Play()
	{
		GetTree().ChangeSceneToFile("res://main.tscn");
	}

	// Called when the Options button is pressed
	private void Options()
	{
		GetTree().ChangeSceneToFile("res://options menu/options_menu.tscn");
	}

	// Called when the Quit button is pressed
	private void Quit()
	{
		GetTree().Quit();
	}
}
