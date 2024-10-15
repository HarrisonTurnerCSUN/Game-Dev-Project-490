using Godot;
using System;


public class GameData
{
	//List of settings variables here include constants for defualts
	public int WindowMode {get; set;}
	public float MasterVol {get; set;}
	public float MusicVol {get; set;}
	public float SFXVol {get; set;}
	
	public void init (){
		WindowMode = 0;
		MasterVol = 0.5f;
		MusicVol = 0.5f;
		SFXVol = 0.5f;
	}
	
	public void setWindowMode (int x){ WindowMode = x; }
	public int getWindowMode (){ return WindowMode; }
	
	public void setVolume (String busName, float vol){
		if (busName == "Master"){
			setMasterVol(vol);
		}
		else if (busName == "Music"){
			setMusicVol(vol);
		}
		else if (busName == "SFX"){
			setSFXVol(vol);
		}
	}
	
	public float getVolume (String busName){
		if (busName == "Master"){
			return getMasterVol();
		}
		else if (busName == "Music"){
			return getMusicVol();
		}
		else if (busName == "SFX"){
			return getSFXVol();
		}
		return 0.5f;
	}
	
	public void setMasterVol (float x){ MasterVol = x; }
	public float getMasterVol (){ return MasterVol; }
	
	public void setMusicVol (float x){ MusicVol = x; }
	public float getMusicVol (){ return MusicVol; }
	
	public void setSFXVol (float x){ SFXVol = x; }
	public float getSFXVol (){ return SFXVol; }
}
