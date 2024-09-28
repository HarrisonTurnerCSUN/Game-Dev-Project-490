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
	
	public override void _Ready(){
		SaveController.loadGame();
		if (SaveController.gameData.WindowMode == 0){
			DisplayServer.WindowSetMode(DisplayServer.WindowMode.Fullscreen);
			DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless,false);
		} else if (SaveController.gameData.WindowMode == 1){
			DisplayServer.WindowSetMode(DisplayServer.WindowMode.Windowed);
			DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless,false);
		}
	}
}
