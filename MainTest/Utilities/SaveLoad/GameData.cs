using Godot;
using System;


public class GameData
{
	//List of settings variables here include constants for defualts
	public int WindowMode {get; set;}
	
	public void init (){
		WindowMode = 1;
	}
	
	public void setWindowMode (int x){
		WindowMode = x;
	}
	
	public int getWindowMode (){
		return WindowMode;
	}
}
