package entity;

import models.weapons.Range;
import customCollisionEngine.ICollider;
import kha.math.FastVector2;
import com.framework.utils.Entity;
import com.gEngine.helper.RectangleDisplay;
import customCollisionEngine.CollisionBox;
import customCollisionEngine.CollisionEngine;
import states.GlobalGameData;
import kha.FastFloat;

class BulletEntity extends Entity {
	public var collision:CollisionBox;

	private static var spritePivotX:FastFloat = 0.16;
	private static var spritePivotY:FastFloat = 0.24;

	var display:RectangleDisplay;
	var time:Float = 0;
	var damage:Int;
	var damagedEntities:Array<ICollider> = new Array<ICollider>();

	public function new(x:Float, y:Float, dir:FastVector2, weapon:Range) {
		super();
		this.damage = weapon.get_bulletDamage();
		createSprite(dir, weapon);
		createCollisionBox(x, y, dir, weapon);
	}

	function createSprite(dir:FastVector2, weapon:Range) {
		display = new RectangleDisplay();
		display.setColor(0, 0, 0);
		display.rotation = Math.atan2(dir.y, dir.x);
		display.scaleX = weapon.get_bulletWidth();
		display.scaleY = weapon.get_bulletHeight();
		display.pivotX = display.scaleX * spritePivotX;
		display.pivotY = display.scaleY * spritePivotY;
		GlobalGameData.simulationLayer.addChild(display);
	}

	function createCollisionBox(x:Float, y:Float, dir:FastVector2, weapon:Range) {
		collision = new CollisionBox();
		collision.width = collision.height = weapon.get_bulletHeight();
		collision.x = x - weapon.get_bulletWidth() * 0.5;
		collision.y = y - weapon.get_bulletHeight() * 0.5;
		collision.velocityX = dir.x * weapon.get_bulletSpeed();
		collision.velocityY = dir.y * weapon.get_bulletSpeed();
		collision.userData = this;
		collision.staticObject = true;
		display.x = collision.x;
		display.y = collision.y;
	}

	override function update(dt:Float) {
		time += dt;
		if (time > 10)
			die();
		super.update(dt);
		collision.update(dt);
		CollisionEngine.overlap(collision, GlobalGameData.worldMap.collision, overlapWorld);
		CollisionEngine.overlap(collision, GlobalGameData.enemyCollisionGroup, overlapEnemy);
		display.x = collision.x;
		display.y = collision.y;
	}

	function overlapEnemy(col1:ICollider, col2:ICollider) {
		if (damagedEntities.indexOf(col1) == -1) {
			damagedEntities.push(col1);
			col1.userData.recieveDamage(damage);
		}
	}

	function overlapWorld(col1:ICollider, col2:ICollider) {
		destroy();
	}

	override function destroy() {
		super.destroy();
		collision.removeFromParent();
		display.removeFromParent();
		die();
	}
}
