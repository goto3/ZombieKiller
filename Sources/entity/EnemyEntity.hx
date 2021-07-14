package entity;

import models.enemies.GenericZombie;
import models.enemies.Zombe1;
import states.GlobalGameData;
import models.Enemy;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;
import customCollisionEngine.CollisionEngine;
import customCollisionEngine.CollisionBox;

class EnemyEntity extends Entity {
	public var enemy:Enemy;

	public var sprite:Sprite;
	public var collision:CollisionBox;

	public function new(type:String, x:Int, y:Int, visionLock:Bool = false, drop:Bool = false) {
		super();
		switch type {
			case "zombie1":
				this.enemy = new Zombie1(this, visionLock, drop);
			case "genericZombie":
				this.enemy = new GenericZombie(this, visionLock, drop);
		}

		createSprite();
		createCollisionBox(x, y);
	}

	override function update(dt:Float) {
		super.update(dt);
		this.enemy.runAI(dt);
		collision.update(dt);
		CollisionEngine.collide(this.collision, GlobalGameData.worldMap.collision);
		CollisionEngine.collide(this.collision, GlobalGameData.enemyCollisionGroup);
		CollisionEngine.collide(this.collision, GlobalGameData.playerEntity.collision);
	}

	override function render() {
		super.render();
		this.enemy.playAnimation();
		sprite.x = collision.x;
		sprite.y = collision.y;
	}

	function createSprite() {
		sprite = new Sprite(this.enemy.getSpriteName());
		sprite.smooth = false;
		sprite.scaleX = this.enemy.getScaleX();
		sprite.scaleY = this.enemy.getScaleY();
		sprite.pivotX = sprite.width() * sprite.scaleX * this.enemy.getSpritePivotX();
		sprite.pivotY = sprite.height() * sprite.scaleY * this.enemy.getSpritePivotY();
		sprite.offsetX = -sprite.width() * sprite.scaleX * this.enemy.getSpriteOffestX();
		sprite.offsetY = -sprite.height() * sprite.scaleY * this.enemy.getSpriteOffestY();
		GlobalGameData.simulationLayer.addChild(sprite);
	}

	function createCollisionBox(x:Int, y:Int) {
		collision = new CollisionBox();
		collision.width = sprite.width() * sprite.scaleX * this.enemy.getCollisionBoxScaleX();
		collision.height = sprite.height() * sprite.scaleY * this.enemy.getCollisionBoxScaleY();
		collision.userData = this;
		collision.x = x;
		collision.y = y;
		GlobalGameData.enemyCollisionGroup.add(this.collision);
	}

	public function recieveDamage(amount:Int) {
		enemy.recieveDamage(amount);
	}

	override function destroy() {
		super.destroy();
		this.collision.removeFromParent();
		this.sprite.removeFromParent();
		die();
	}
}
