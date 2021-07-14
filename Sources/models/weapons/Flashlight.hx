package models.weapons;

import com.soundLib.SoundManager.SM;
import customCollisionEngine.CollisionCircle;
import kha.math.FastVector2;
import entity.EnemyEntity;
import customCollisionEngine.CollisionEngine;
import states.GlobalGameData;
import com.gEngine.display.Sprite;
import kha.FastFloat;
import helpers.Helpers;

class FlashLight extends Melee {
	private static var spriteScaleX:FastFloat = 0.6;
	private static var spriteScaleY:FastFloat = 0.6;
	private static var spritePivotX:FastFloat = 0.65;
	private static var spritePivotY:FastFloat = 0.87;
	private static var spriteOffsetX:FastFloat = 0.34;
	private static var spriteOffsetY:FastFloat = 0.56;
	private static final atlasImageName:String = "soldierFlashlightSmall";

	var timeFromLastAttack:Float = 1;
	var attackQueued:Bool = false;
	var attacking:Bool = false;

	public function new() {
		super();
	}

	public override function createSprite():Sprite {
		var sprite:Sprite = new Sprite(atlasImageName);
		sprite.smooth = false;
		sprite.scaleX = spriteScaleX;
		sprite.scaleY = spriteScaleY;
		sprite.pivotX = sprite.width() * sprite.scaleX * spritePivotX;
		sprite.pivotY = sprite.height() * sprite.scaleY * spritePivotY;
		sprite.offsetX = -sprite.width() * sprite.scaleX * spriteOffsetX;
		sprite.offsetY = -sprite.height() * sprite.scaleY * spriteOffsetY;
		return sprite;
	}

	public override function attack() {
		if (timeFromLastAttack * 1000 > GlobalGameData.meleeAtkSpd) {
			SM.playFx("punch");
			timeFromLastAttack = 0;
			attackQueued = true;
		}
	}

	public override function updateAnimation(dt:Float, sprite:Sprite, moving:Bool) {
		timeFromLastAttack += dt;
		attacking = timeFromLastAttack < 0.4;
		if (attacking) {
			sprite.timeline.frameRate = 0.02;
			sprite.timeline.playAnimation("attack");
		} else if (moving) {
			sprite.timeline.frameRate = 0.05;
			sprite.timeline.playAnimation("move");
		} else if (!moving) {
			sprite.timeline.frameRate = 0.1;
			sprite.timeline.playAnimation("idle");
		}
		if (attackQueued && timeFromLastAttack > 0.2)
			castAttack();
	}

	private function castAttack() {
		attackQueued = false;
		attacking = false;
		var range:Int = GlobalGameData.meleeRange;
		var facingDir:FastVector2 = Helpers.getFacingDir(GlobalGameData.playerEntity.collision);
		var hitCollision = new CollisionCircle(range);
		hitCollision.x = (GlobalGameData.playerEntity.collision.x
			+ GlobalGameData.playerEntity.collision.width * 0.5)
			+ facingDir.x * range * 0.5
			- range;
		hitCollision.y = (GlobalGameData.playerEntity.collision.y
			+ GlobalGameData.playerEntity.collision.height * 0.5)
			+ facingDir.y * range * 0.5
			- range;
		CollisionEngine.overlap(GlobalGameData.enemyCollisionGroup, hitCollision, (c1, c2) -> {
			cast(c1.userData, EnemyEntity).recieveDamage(GlobalGameData.meleeDmg);
		});
	}

	public override function getAtlasImageName():String {
		return atlasImageName;
	}
}
