package models.weapons;

import com.gEngine.display.Sprite;

class Weapon {
	public function new() {}

	public function createSprite():Sprite {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function getAtlasImageName():String {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function manualAdjunstPivotAndOffset(sprite:Sprite) {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function attack() {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function updateAnimation(dt:Float, sprite:Sprite, moving:Bool) {
		throw new haxe.exceptions.NotImplementedException();
	}
}
