package models.weapons;

import com.soundLib.SoundManager.SM;
import kha.math.FastVector2;
import helpers.Helpers;
import entity.BulletEntity;
import com.gEngine.display.Sprite;
import kha.FastFloat;
import states.GlobalGameData;

class Ak47 extends Range {
	@:isVar public var totalAmmo(get, set):Int;

	private static var spriteScaleX:FastFloat = 0.6;
	private static var spriteScaleY:FastFloat = 0.6;
	private static var spritePivotX:FastFloat = 0.56;
	private static var spritePivotY:FastFloat = 0.86;
	private static var spriteOffsetX:FastFloat = 0.26;
	private static var spriteOffsetY:FastFloat = 0.49;
	private static final atlasImageName:String = "soldierAK47Small";

	private static final bulletSpeed:Int = GlobalGameData.ak47BulletSpd;
	private static final bulletWidth:Int = GlobalGameData.ak47BulletWidth;
	private static final bulletHeight:Int = GlobalGameData.ak47BulletHeight;
	private static final bulletDamage:Int = GlobalGameData.ak47BulletDamage;

	var lastAttack:Float = 1;

	public function new() {
		super();
		this.totalAmmo = GlobalGameData.ak47PickupAmmo;
	}

	public override function get_totalAmmo() {
		return totalAmmo;
	}

	function set_totalAmmo(value:Int) {
		GlobalGameData.hud.updateAmmo(3, value);
		return totalAmmo = Math.floor(Math.min(value, GlobalGameData.ak47MaxAmmo));
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
		if (totalAmmo > 0 && lastAttack * 1000 >= GlobalGameData.ak47AtkSpd) {
			SM.playFx("gunshotAK");
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
