package models.enemies;

import kha.math.FastVector2;
import states.GlobalGameData;
import entity.PhotonEntity;
import customCollisionEngine.CollisionBox;
import kha.FastFloat;
import entity.EnemyEntity;

class Zombie1 extends Enemy {
	// Sprite parameters
	static final scaleX:FastFloat = 1;
	static final scaleY:FastFloat = 1;
	static var spritePivotX:FastFloat = 0.39;
	static var spritePivotY:FastFloat = 0.54;
	static var spriteOffsetX:FastFloat = 0.179;
	static var spriteOffsetY:FastFloat = 0.34;
	static final collisionBoxScaleX:Float = 0.45;
	static final collisionBoxScaleY:Float = 0.45;
	static final spriteName:String = "zombie1Small";

	// A.I. parameters
	static final damage:Float = GlobalGameData.z1Damage;
	static final atkSpd:Int = GlobalGameData.z1AtkSpd;
	static final runSpeed:Int = GlobalGameData.z1RunSpd;

	var health:Int = 100;

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
		this.visionLock = visionLock;
		this.drop = drop;
	}

	public override function runAI(dt:Float) {
		if (visionLock) {
			this.facingDir = getFacingDir(new FastVector2(GlobalGameData.playerEntity.collision.x, GlobalGameData.playerEntity.collision.y));
			this.entity.collision.velocityX = this.facingDir.x * runSpeed;
			this.entity.collision.velocityY = this.facingDir.y * runSpeed;
			this.entity.sprite.rotation = Math.atan2(this.facingDir.y, this.facingDir.x);
		} else {
			castVisionRay();

			this.entity.collision.velocityX = this.entity.collision.velocityY = 0;
			if (agro) {
				var distance:Float = distanceToTarget();
				this.agro = distance > 20;
				if (distance > 20) {
					this.facingDir = getFacingDir(this.lastSeenPlayerPos);
					this.entity.sprite.rotation = Math.atan2(this.facingDir.y, this.facingDir.x);
					this.entity.collision.velocityX = this.facingDir.x * runSpeed;
					this.entity.collision.velocityY = this.facingDir.y * runSpeed;
				}
			}
		}
		if (this.playerCollision.areTouching(this.entity.collision))
			hitPlayer();
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
		if (Date.now().getTime() - lastHit.getTime() < 200) {
			this.entity.sprite.timeline.frameRate = 0.04;
			this.entity.sprite.timeline.playAnimation("attack");
		} else if (entity.collision.velocityX != 0 || entity.collision.velocityY != 0) {
			this.entity.sprite.timeline.frameRate = 0.01;
			this.entity.sprite.timeline.playAnimation("move");
		} else {
			this.entity.sprite.timeline.frameRate = 0.1;
			this.entity.sprite.timeline.playAnimation("idle");
		}
	}

	public override function recieveDamage(amount:Int) {
		this.health -= amount;
		if (this.health <= 0) {
			GlobalGameData.playerEntity.player.score += 10;
			var random = Std.random(100) + 1;
			if (random < 20)
				GlobalGameData.currentLevel.spawnRandomItem(this.entity.collision.x, this.entity.collision.y);
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
