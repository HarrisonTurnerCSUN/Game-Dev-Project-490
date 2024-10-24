using Godot;
using System;

public partial class Menu : Control
{
	private AudioStreamPlayer _audioPopUp;
	private AudioStreamPlayer _audioSelect;
	private AudioStreamPlayer _audioCursor;
	private AudioStreamPlayer _audioClose;

	// Called when the Play button is pressed
	private void Play()
	{
		_audioPopUp.Play();
		GetTree().ChangeSceneToFile("res://Levels/Testing/main.tscn");
	}

	// Called when the Options button is pressed
	private void Options()
	{
		_audioCursor.Play();
		GetTree().ChangeSceneToFile("res://main menu/options menu/options_menu.tscn");
	}

	// Called when the Quit button is pressed
	private void Quit()
	{
		_audioClose.Play();
		GetTree().Quit();
	}
	
	public override void _Ready(){
		//BGM
		var music = (AudioStream)GD.Load("res://Assets/AudioAssets/Infinity Crystal_ Awakening wavs/1 titles LOOP.wav");
		var audioManager = GetNode("/root/AudioManager");
		audioManager.Call("play_music", music);
		//SFX
		_audioPopUp = GetNode<AudioStreamPlayer>("AudioPopUp");
		_audioSelect = GetNode<AudioStreamPlayer>("AudioSelect");
		_audioCursor = GetNode<AudioStreamPlayer>("AudioCursor");
		_audioClose = GetNode<AudioStreamPlayer>("AudioClose");
		
		int busIndex;
		SaveController.loadGame();
		busIndex = AudioServer.GetBusIndex("Master");
		GD.Print(SaveController.gameData.MasterVol);
		AudioServer.SetBusVolumeDb(busIndex, Mathf.LinearToDb(SaveController.gameData.MasterVol));
		busIndex = AudioServer.GetBusIndex("Music");
		AudioServer.SetBusVolumeDb(busIndex, Mathf.LinearToDb(SaveController.gameData.MusicVol));
		busIndex = AudioServer.GetBusIndex("SFX");
		AudioServer.SetBusVolumeDb(busIndex, Mathf.LinearToDb(SaveController.gameData.SFXVol));
		if (SaveController.gameData.WindowMode == 0){
			_audioSelect.Play();
			DisplayServer.WindowSetMode(DisplayServer.WindowMode.Fullscreen);
			DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless,false);
		} else if (SaveController.gameData.WindowMode == 1){
			_audioSelect.Play();
			DisplayServer.WindowSetMode(DisplayServer.WindowMode.Windowed);
			DisplayServer.WindowSetFlag(DisplayServer.WindowFlags.Borderless,false);
		}
		
	}
}
