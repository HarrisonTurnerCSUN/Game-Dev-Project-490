using Godot;
using System;
using System.Collections.Generic;
using System.Text.Json;

//Code is a common json serialization system of saving, based on "vidyagamemaka" save load code
// but altered for single file and needs of project
public partial class SaveController : Node
{
	[Signal]
	public delegate void PotionAddedEventHandler();

	public static PlayerData playerData = new PlayerData();
	
	public static GameData gameData = new GameData();
	
	public enum SaveType {playerDat, gameDat}
	
	//public access calls to save and load functions
	public static void savePlayer() { save(SaveType.playerDat); }
	public static void saveGame() { save(SaveType.gameDat); }
	
	public static void loadPlayer() { load(SaveType.playerDat); }
	public static void loadGame() { load(SaveType.gameDat); }
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("SaveController initialized");
		playerData.init();
		GD.Print("playerData initialized");
		gameData.init();
		loadGame();
		GD.Print("gameData initialized");
		GD.Print(gameData.WindowMode);
		
		//playerData = new PlayerData
		//{
		//	checkpoint = 0,
		//	overworldCheckpoint = 0, 
		//	savedScene = "temp"
		//};
		//var gameData = new GameData
		//{
		//	testVar = true
		//};
		
		//playerData.savedScene = GetSceneFilePath();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	private static void save(SaveType type){
		string filePath = "user://" + type.ToString() + ".sav";
		
		using var saveGame = FileAccess.Open(filePath,FileAccess.ModeFlags.Write);
		
		string jsonString = string.Empty;
		if(type == SaveType.playerDat){
			//jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(playerData);
			jsonString = JsonSerializer.Serialize(playerData);
			GD.Print("Saving to: " + filePath);
		}
		if(type == SaveType.gameDat){
			//jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(gameData);
			jsonString = JsonSerializer.Serialize(gameData);
			GD.Print("Saving to: " + filePath);
		}
		
		saveGame.StoreLine(jsonString);
	}
	
	private static void load(SaveType type){
		string filePath = "user://" + type.ToString() + ".sav";
		
		if(FileAccess.FileExists(filePath) == false){
			GD.Print("No file");
			return;
		}
		
		using var saveGame = FileAccess.Open(filePath,FileAccess.ModeFlags.Read);
		
		var jsonString = saveGame.GetLine();
		// bellow is for reading the entire file content but currently only on
		// one line
		// var jsonString = saveGame.GetAsText();  
		
		if(type == SaveType.playerDat){
			//Newtonsoft.Json.JsonConvert.PopulateObject(jsonString, playerData);
			playerData = JsonSerializer.Deserialize<PlayerData>(jsonString)!;
			GD.Print(playerData.savedScene);
		}
		if(type == SaveType.gameDat){
			//Newtonsoft.Json.JsonConvert.PopulateObject(jsonString, gameData);
			gameData = JsonSerializer.Deserialize<GameData>(jsonString)!;
		}
	}

	public static void setWindowMode(int x){ gameData.setWindowMode(x); }
	public void getWindowMode(){ gameData.getWindowMode(); }
	
	public static void setVolume(String bus_name,float vol) { 
		gameData.setVolume(bus_name,vol); 
	}
	
	public static void setSavedScene(string x){ playerData.setSavedScene(x); }
	public string getSavedScene(){ return playerData.getSavedScene();}
	
	public static void setOverworldPositionX (int x){ playerData.setOverworldPositionX(x);}
	public float getOverworldPositionX () { return playerData.getOverworldPositionX();}
	
	public static void setOverworldPositionY (int x){ playerData.setOverworldPositionY(x);}
	public float getOverworldPositionY () { return playerData.getOverworldPositionY();}
	
	public static List<string> Inventory { get; set; } = new List<string>();
	public static void setPlayerInventory(){ playerData.setPlayerInventory(Inventory); }
	public void getPlayerInventory(){ Inventory = playerData.getPlayerInventory(); }
	
	public void addPotion(string item)
	{
		getPlayerInventory();
		Inventory.Add(item);
		EmitSignal("PotionAdded");
		setPlayerInventory();
	}
	public static int getPotionCount(string item)
	{
		int count = 0;
		// Iterate through the list and count occurrences of the item
		foreach (var potion in Inventory)
		{
			if (potion == item)
			{
				count++;
			}
		}

		return count;  // Return the number of times the potion appears
	}

}
