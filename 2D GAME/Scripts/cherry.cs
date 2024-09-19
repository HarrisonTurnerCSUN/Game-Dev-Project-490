using Godot;
using System;

public partial class cherry : Area2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		BodyEntered += OnBodyEntered;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public void OnBodyEntered(Node body)
	{
		if (body.Name == "CharacterBody2D")
		{
			QueueFree();
		}
	}
}
