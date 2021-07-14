package entity;

import customCollisionEngine.ICollider;
import kha.math.FastVector2;
import com.framework.utils.Entity;
import customCollisionEngine.CollisionBox;
import customCollisionEngine.CollisionEngine;
import states.GlobalGameData;
import models.Enemy;

class PhotonEntity extends Entity {
	public var collision:CollisionBox;

	var time:Float = 0;
	var owner:Enemy;

	public function new(startX:Float, startY:Float, endX:Float, endY:Float, owner:Enemy) {
		super();
		this.owner = owner;
		createCollisionBox(startX, startY, endX, endY);
	}

	function createCollisionBox(startX:Float, startY:Float, endX:Float, endY:Float) {
		collision = new CollisionBox();
		collision.width = GlobalGameData.photonWidth;
		collision.height = GlobalGameData.photonHeight;
		collision.x = startX;
		collision.y = startY;
		var speed:Int = Std.random(500);
		var facingDir:FastVector2 = getFacingDir(startX, startY, endX, endY);
		collision.velocityX = facingDir.x * (GlobalGameData.photonSpeed + speed);
		collision.velocityY = facingDir.y * (GlobalGameData.photonSpeed + speed);
	}

	inline function getFacingDir(startX:Float, startY:Float, endX:Float, endY:Float):FastVector2 {
		return new FastVector2(endX - startX, endY - startY).normalized(); // Final - Inicial
	}

	override function update(dt:Float) {
		time += dt;
		if (time > 0.5)
			destroy();

		super.update(dt);
		collision.update(dt);

		CollisionEngine.overlap(collision, GlobalGameData.worldMap.collision, function(c1, c2) destroy());
		CollisionEngine.overlap(collision, GlobalGameData.playerEntity.collision, handleOverlap);
	}

	function handleOverlap(c1:ICollider, c2:ICollider) {
		owner.setVision();
		destroy();
	}

	override function destroy() {
		super.destroy();
		collision.removeFromParent();
		die();
	}
}
