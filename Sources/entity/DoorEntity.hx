package entity;

import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import customCollisionEngine.CollisionEngine;
import customCollisionEngine.CollisionBox;
import states.GlobalGameData;

class DoorEntity extends Entity {
	public var sprite:Sprite;
	public var collision:CollisionBox;

	public function new(x:Float, y:Float) {
		super();
		createSprite(x, y);
		createCollisionBox(x, y);
	}

	function createSprite(x:Float, y:Float) {
		sprite = new Sprite("tiles2");
		sprite.smooth = false;
		sprite.scaleX = sprite.scaleY = 1;
		sprite.x = x;
		sprite.y = y;
		sprite.timeline.gotoAndStop(340);
		GlobalGameData.simulationLayer.addChild(sprite);
	}

	function createCollisionBox(x:Float, y:Float) {
		collision = new CollisionBox();
		collision.width = sprite.width() * sprite.scaleX;
		collision.height = sprite.height() * sprite.scaleY;
		collision.x = x;
		collision.y = y;
		collision.staticObject = true;
	}

	override function update(dt:Float) {
		super.update(dt);
		CollisionEngine.collide(collision, GlobalGameData.playerEntity.collision);
	}

	override function render() {
		super.render();
	}

	override function destroy() {
		super.destroy();
		die();
		sprite.removeFromParent();
		collision.removeFromParent();
	}
}
