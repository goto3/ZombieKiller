package entity;

import helpers.Helpers;
import models.Player;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import kha.math.FastVector2;
import customCollisionEngine.CollisionEngine;
import customCollisionEngine.CollisionGroup;
import customCollisionEngine.CollisionBox;
import states.GlobalGameData;

class PlayerEntity extends Entity {
	public var player:Player;
	public var sprite:Sprite;
	public var collision:CollisionBox;
	public var bulletsCollision:CollisionGroup;

	var dir:FastVector2 = new FastVector2();
	var moving:Bool = false;

	public function new(x:Float, y:Float) {
		super();
		this.player = new Player();
		GlobalGameData.playerEntity = this;
		createSprite();
		createCollisionBox(x, y);
	}

	public function createSprite() {
		if (sprite != null && sprite.timeline.currentAnimation != player.activeSlot.getAtlasImageName()) {
			sprite.removeFromParent();
			sprite = null;
		}
		if (sprite == null) {
			sprite = GlobalGameData.playerEntity.player.activeSlot.createSprite();
			GlobalGameData.simulationLayer.addChild(sprite);
		}
	}

	function createCollisionBox(x:Float, y:Float) {
		collision = new CollisionBox();
		bulletsCollision = new CollisionGroup();
		collision.width = sprite.width() * sprite.scaleX * 0.6;
		collision.height = sprite.height() * sprite.scaleY * 0.6;
		collision.userData = this;
		collision.x = x;
		collision.y = y;
		collision.staticObject = true;
	}

	override function update(dt:Float) {
		super.update(dt);

		processInput(dt);
		collision.update(dt);
		CollisionEngine.collide(this.collision, GlobalGameData.worldMap.collision);

		player.activeSlot.updateAnimation(dt, sprite, moving);
	}

	public function processInput(dt:Float) {
		dir = dir.mult(0);
		collision.velocityX = 0;
		collision.velocityY = 0;
		if (Input.i.isKeyCodeDown(KeyCode.A))
			dir.x += -1;
		if (Input.i.isKeyCodeDown(KeyCode.D))
			dir.x += 1;
		if (Input.i.isKeyCodeDown(KeyCode.W))
			dir.y += -1;
		if (Input.i.isKeyCodeDown(KeyCode.S))
			dir.y += 1;
		if (GlobalGameData.hud.activeSlot == 3 && Input.i.isMouseDown())
			player.activeSlot.attack();
		if (GlobalGameData.hud.activeSlot != 3 && Input.i.isMousePressed())
			player.activeSlot.attack();
		if (Input.i.isKeyCodePressed(KeyCode.One))
			player.selectSlot(1);
		if (Input.i.isKeyCodePressed(KeyCode.Two))
			player.selectSlot(2);
		if (Input.i.isKeyCodePressed(KeyCode.Three))
			player.selectSlot(3);
		if (Input.i.isKeyCodePressed(KeyCode.Four))
			player.selectSlot(4);

		moving = dir.length != 0;
		if (moving) {
			dir = dir.normalized().mult(GlobalGameData.playerMoveSpeed);
			collision.velocityX = dir.x;
			collision.velocityY = dir.y;
		}
	}

	override function render() {
		var facingDir:FastVector2 = Helpers.getFacingDir(collision);
		sprite.rotation = Math.atan2(facingDir.y, facingDir.x);
		sprite.x = collision.x;
		sprite.y = collision.y;
	}

	public function heal(amount:Int) {
		player.health += amount;
	}

	public function recieveDamage(amount:Float) {
		player.health -= amount;
	}
}
