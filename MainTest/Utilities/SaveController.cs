using Godot;
using System;
using System.Text.Json;


public partial class SaveController : Node
{
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
	
	public GameData getGameData(){
		return gameData;
	}
}
