using Godot;
using System;
using System.Collections.Generic;

public class PlayerData
{
	//List of player data variables
	public int checkpoint {get; set;}
	public int overworldCheckpoint {get; set;}
	public float overworldPositionX {get; set;}
	public float overworldPositionY {get; set;}
	public string savedScene {get; set;}
	public List<string> Inventory { get; set; }
	
	//public Godot.Collections.Dictionary<string ,int> saveDictionary = 
	//	new Godot.Collections.Dictionary<string ,int>();
		
	//Using init but can use a constructor instead to set the base class vals
	public void init(){
		checkpoint = 0;
		overworldCheckpoint = 0;
		overworldPositionX = 448;
		overworldPositionY = 666;
		savedScene = "res://Overworld/overworld.tscn";
		Inventory = new List<string>();
		//allows storing of dictionary of simple data types, maybe useful
		//playerDictionary.Add("zero",0);
	}
	public void setSavedScene (string x){ savedScene = x;}
	public string getSavedScene () { return savedScene;}
	
	public void setOverworldPositionX (int x){ overworldPositionX = x;}
	public float getOverworldPositionX () { return overworldPositionX;}
	
	public void setOverworldPositionY (int x){ overworldPositionY = x;}
	public float getOverworldPositionY () { return overworldPositionY;}
	
	public void setPlayerInventory(List<string> x){ Inventory = x; }
	public List<string> getPlayerInventory(){ return Inventory; }
}
