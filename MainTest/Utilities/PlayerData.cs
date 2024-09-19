using Godot;
using System;

public class PlayerData
{
	//List of player data variables
	public int checkpoint {get; set;}
	public int overworldCheckpoint {get; set;}
	public bool isInOverworld {get; set;}
	public string savedScene {get; set;}
	
	//public Godot.Collections.Dictionary<string ,int> saveDictionary = 
	//	new Godot.Collections.Dictionary<string ,int>();
		
	//Using init but can use a constructor instead to set the base class vals
	public void init(){
		checkpoint = 0;
		overworldCheckpoint = 0;
		isInOverworld = false;
		savedScene = "res://Scenes/game.tscn";
		//allows storing of dictionary of simple data types, maybe useful
		//playerDictionary.Add("zero",0);
	}
}
