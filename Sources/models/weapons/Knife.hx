package models.weapons;

import com.soundLib.SoundManager.SM;
import entity.EnemyEntity;
import customCollisionEngine.CollisionEngine;
import customCollisionEngine.CollisionCircle;
import helpers.Helpers;
import kha.math.FastVector2;
import com.gEngine.display.Sprite;
import kha.FastFloat;
import states.GlobalGameData;

class Knife extends Melee {
	private static var spriteScaleX:FastFloat = 0.65;
	private static var spriteScaleY:FastFloat = 0.65;
	private static var spritePivotX:FastFloat = 0.63;
	private static var spritePivotY:FastFloat = 0.73;
	private static var spriteOffsetX:FastFloat = 0.33;
	private static var spriteOffsetY:FastFloat = 0.42;
	private static final atlasImageName:String = "soldierKnifeSmall";

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
		if (timeFromLastAttack * 1000 > GlobalGameData.knifeAtkSpd) {
			SM.playFx("knifeAttack");
			timeFromLastAttack = 0;
			attackQueued = true;
		}
	}

	public override function updateAnimation(dt:Float, sprite:Sprite, moving:Bool) {
		timeFromLastAttack += dt;
		attacking = timeFromLastAttack < 0.3;
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
		if (attackQueued && timeFromLastAttack > 0.18)
			castAttack();
	}

	private function castAttack() {
		attackQueued = false;
		var range:Int = GlobalGameData.knifeRange;
		var facingDir:FastVector2 = Helpers.getFacingDir(GlobalGameData.playerEntity.collision);
		var hitCollision = new CollisionCircle(range);
		hitCollision.x = GlobalGameData.playerEntity.collision.x
			+ GlobalGameData.playerEntity.collision.width * 0.5
			+ facingDir.x * range * 0.5
			- range;
		hitCollision.y = GlobalGameData.playerEntity.collision.y
			+ GlobalGameData.playerEntity.collision.height * 0.5
			+ facingDir.y * range * 0.5
			- range;
		CollisionEngine.overlap(GlobalGameData.enemyCollisionGroup, hitCollision, (c1, c2) -> {
			cast(c1.userData, EnemyEntity).recieveDamage(GlobalGameData.knifeDmg);
		});
	}

	public override function getAtlasImageName():String {
		return atlasImageName;
	}
}
