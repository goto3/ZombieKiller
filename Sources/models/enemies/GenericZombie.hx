package models.enemies;

import kha.math.FastVector2;
import states.GlobalGameData;
import entity.PhotonEntity;
import customCollisionEngine.CollisionBox;
import kha.FastFloat;
import kha.math.Random;
import entity.EnemyEntity;

class GenericZombie extends Enemy {
	// Sprite parameters
	static final scaleX:FastFloat = 1.25;
	static final scaleY:FastFloat = 1.25;
	static var spritePivotX:FastFloat = 0.39;
	static var spritePivotY:FastFloat = 0.54;
	static var spriteOffsetX:FastFloat = -0.01;
	static var spriteOffsetY:FastFloat = 0.07;
	static final collisionBoxScaleX:Float = 0.6;
	static final collisionBoxScaleY:Float = 0.6;
	static final spriteName:String = "genericZombie";

	// A.I. parameters
	static final damage:Float = GlobalGameData.gzDamage;
	static final atkSpd:Int = GlobalGameData.gzAtkSpd;
	static final runSpeed:Int = GlobalGameData.gzRunSpd;

	var health:Int = 100;
	var zombieNumber:Int;

	// Entity parameters
	var entity:EnemyEntity;
	var lastHit:Date = Date.now();
	var playerCollision:CollisionBox = GlobalGameData.playerEntity.collision;
	var agro:Bool = false;
	var facingDir:FastVector2 = new FastVector2();
	var lastSeenPlayerPos:FastVector2;
	var visionLock:Bool = false;
	var drop:Bool = false;

	public function new(entity:EnemyEntity, visionLock:Bool = false, drop:Bool = false) {
		super();
		this.entity = entity;
		zombieNumber = Math.floor(Random.getFloatIn(1, 9));
		this.visionLock = visionLock;
		this.drop = drop;
	}

	public override function runAI(dt:Float) {
		if (visionLock) {
			this.facingDir = getFacingDir(new FastVector2(GlobalGameData.playerEntity.collision.x, GlobalGameData.playerEntity.collision.y));
			this.entity.collision.velocityX = this.facingDir.x * runSpeed;
			this.entity.collision.velocityY = this.facingDir.y * runSpeed;
		} else {
			castVisionRay();

			this.entity.collision.velocityX = this.entity.collision.velocityY = 0;
			if (agro) {
				var distance:Float = distanceToTarget();
				this.agro = distance > 20;
				if (distance > 20) {
					this.facingDir = getFacingDir(this.lastSeenPlayerPos);
					// this.entity.sprite.rotation = Math.atan2(this.facingDir.y, this.facingDir.x);
					this.entity.collision.velocityX = this.facingDir.x * runSpeed;
					this.entity.collision.velocityY = this.facingDir.y * runSpeed;
				}
				if (this.playerCollision.areTouching(this.entity.collision))
					hitPlayer();
			}
		}
	}

	function castVisionRay() {
		var photonX:Float = this.entity.collision.x + this.entity.collision.width * 0.5;
		var photonY:Float = this.entity.collision.y + this.entity.collision.height * 0.5;
		var playerX:Float = this.playerCollision.x + this.playerCollision.width * 0.5;
		var playerY:Float = this.playerCollision.y + this.playerCollision.height * 0.5;
		var photon:PhotonEntity = new PhotonEntity(photonX, photonY, playerX, playerY, this);
		this.entity.addChild(photon);
	}

	inline function distanceToTarget() {
		return Math.sqrt(Math.pow(this.lastSeenPlayerPos.x - (this.entity.collision.x + this.entity.collision.width * 0.5), 2)
			+ Math.pow(this.lastSeenPlayerPos.y - (this.entity.collision.y + this.entity.collision.height * 0.5), 2));
	}

	inline function getFacingDir(target:FastVector2):FastVector2 {
		var photonX:Float = entity.collision.x + entity.collision.width * 0.5;
		var photonY:Float = entity.collision.y + entity.collision.height * 0.5;
		return new FastVector2(target.x - photonX, target.y - photonY).normalized(); // Final - Inicial
	}

	public function hitPlayer() {
		var fromLastDamage:FastFloat = Date.now().getTime() - lastHit.getTime();
		if (fromLastDamage > atkSpd) {
			this.lastHit = Date.now();
			GlobalGameData.playerEntity.recieveDamage(damage);
		}
	}

	public override function playAnimation() {
		this.entity.sprite.timeline.frameRate = 0.1;
		if (entity.collision.velocityX > 0) {
			if (entity.collision.velocityY > 0) {
				if (entity.collision.velocityY > entity.collision.velocityX) {
					this.entity.sprite.timeline.playAnimation("zombie" + zombieNumber + "Down");
				} else {
					this.entity.sprite.timeline.playAnimation("zombie" + zombieNumber + "Right");
				}
			} else {
				if (Math.abs(entity.collision.velocityY) > entity.collision.velocityX) {
					this.entity.sprite.timeline.playAnimation("zombie" + zombieNumber + "Up");
				} else {
					this.entity.sprite.timeline.playAnimation("zombie" + zombieNumber + "Right");
				}
			}
		} else {
			if (entity.collision.velocityY > 0) {
				if (entity.collision.velocityY > Math.abs(entity.collision.velocityX)) {
					this.entity.sprite.timeline.playAnimation("zombie" + zombieNumber + "Down");
				} else {
					this.entity.sprite.timeline.playAnimation("zombie" + zombieNumber + "Left");
				}
			} else {
				if (Math.abs(entity.collision.velocityY) > Math.abs(entity.collision.velocityX)) {
					this.entity.sprite.timeline.playAnimation("zombie" + zombieNumber + "Up");
				} else {
					this.entity.sprite.timeline.playAnimation("zombie" + zombieNumber + "Left");
				}
			}
		}
	}

	inline function randomRange(min:Int, max:Int):Int {
		return Math.floor(Math.random() * (1 + max - min)) + min;
	}

	public override function recieveDamage(amount:Int) {
		this.health -= amount;
		if (this.health <= 0) {
			var random = Std.random(100) + 1;
			if (random < 5)
				GlobalGameData.currentLevel.spawnRandomItem(this.entity.collision.x, this.entity.collision.y);
			GlobalGameData.playerEntity.player.score += 10;
			entity.destroy();
		}
	}

	public override function setVision() {
		lastSeenPlayerPos = new FastVector2(playerCollision.x + playerCollision.width * 0.5, playerCollision.y + playerCollision.height * 0.5);
		agro = true;
	}

	public override function getEntity():EnemyEntity {
		return entity;
	}

	public override function getSpriteOffestX():Float {
		return spriteOffsetX;
	}

	public override function getSpriteOffestY():Float {
		return spriteOffsetY;
	}

	public override function getCollisionBoxScaleX():Float {
		return collisionBoxScaleX;
	}

	public override function getCollisionBoxScaleY():Float {
		return collisionBoxScaleY;
	}

	public override function getSpriteName():String {
		return spriteName;
	}

	public override function getScaleX():FastFloat {
		return scaleX;
	}

	public override function getScaleY():FastFloat {
		return scaleY;
	}

	public override function getSpritePivotX():FastFloat {
		return spritePivotX;
	}

	public override function getSpritePivotY():FastFloat {
		return spritePivotY;
	}
}
