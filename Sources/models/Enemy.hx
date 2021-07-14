package models;

import kha.FastFloat;
import entity.EnemyEntity;

class Enemy {
	public function new() {}

	public function setVision() {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function playAnimation() {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function runAI(dt:Float) {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function notifyVision() {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function setAgro() {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getCollisionBoxScaleX():Float {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getCollisionBoxScaleY():Float {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getSpriteName():String {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getScaleX():FastFloat {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getScaleY():FastFloat {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getSpriteOffestX():FastFloat {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getSpriteOffestY():FastFloat {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getSpritePivotY():FastFloat {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getSpritePivotX():FastFloat {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function recieveDamage(amount:Int) {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getEntity():EnemyEntity {
		throw new haxe.exceptions.NotImplementedException();
	}
}
