package models.weapons;

import com.soundLib.SoundManager.SM;
import kha.math.FastVector2;
import helpers.Helpers;
import entity.BulletEntity;
import com.gEngine.display.Sprite;
import kha.FastFloat;
import states.GlobalGameData;

class Pistol extends Range {
	@:isVar public var totalAmmo(get, set):Int;

	private static var spriteScaleX:FastFloat = 0.5;
	private static var spriteScaleY:FastFloat = 0.5;
	private static var spritePivotX:FastFloat = 0.92;
	private static var spritePivotY:FastFloat = 1.11;
	private static var spriteOffsetX:FastFloat = 0.56;
	private static var spriteOffsetY:FastFloat = 0.76;
	private static final atlasImageName:String = "soldierPistolSmall";

	private static final bulletSpeed:Int = GlobalGameData.pistolBulletSpd;
	private static final bulletWidth:Int = GlobalGameData.pistolBulletWidth;
	private static final bulletHeight:Int = GlobalGameData.pistolBulletHeight;
	private static final bulletDamage:Int = GlobalGameData.pistolBulletDamage;

	var lastAttack:Float = 1;

	public function new() {
		super();
		this.totalAmmo = GlobalGameData.pistolPickupAmmo;
	}

	public override function get_totalAmmo() {
		return totalAmmo;
	}

	function set_totalAmmo(value:Int) {
		GlobalGameData.hud.updateAmmo(2, value);
		return totalAmmo = Math.floor(Math.min(value, GlobalGameData.pistolMaxAmmo));
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
		if (totalAmmo > 0 && lastAttack * 1000 >= GlobalGameData.pistolAtkSpd) {
			SM.playFx("gunshotPistol");
			lastAttack = 0;
			totalAmmo--;
			var facingDir:FastVector2 = Helpers.getFacingDir(GlobalGameData.playerEntity.collision);
			var x:Float = GlobalGameData.playerEntity.collision.x + GlobalGameData.playerEntity.collision.width * 0.5 * (1 + facingDir.x * 0.5);
			var y:Float = GlobalGameData.playerEntity.collision.y + GlobalGameData.playerEntity.collision.height * 0.5 * (1 + facingDir.y * 0.5);
			var bullet:BulletEntity = new BulletEntity(x, y, facingDir, this);
			GlobalGameData.playerEntity.addChild(bullet);
		}
	}

	public override function updateAnimation(dt:Float, sprite:Sprite, moving:Bool) {
		lastAttack += dt;
		if (lastAttack < 0.3) {
			sprite.timeline.frameRate = 0.1;
			sprite.timeline.playAnimation("attack");
		} else if (moving) {
			sprite.timeline.frameRate = 0.05;
			sprite.timeline.playAnimation("move");
		} else if (!moving) {
			sprite.timeline.frameRate = 0.1;
			sprite.timeline.playAnimation("idle");
		}
	}

	public override function getAtlasImageName():String {
		return atlasImageName;
	}

	public override function get_bulletSpeed():Int {
		return bulletSpeed;
	}

	public override function get_bulletWidth():Int {
		return bulletWidth;
	}

	public override function get_bulletHeight():Int {
		return bulletHeight;
	}

	public override function get_bulletDamage():Int {
		return bulletDamage;
	}
}
