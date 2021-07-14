package states;

import com.gEngine.display.Sprite;
import com.gEngine.display.StaticLayer;
import com.gEngine.helper.RectangleDisplay;
import com.gEngine.display.Text;

class Hud extends StaticLayer {
	var healthBar:RectangleDisplay;
	var waveText:Text;
	var scoreText:Text;

	var maxHealth:Float = GlobalGameData.initialHealth;

	public var activeSlot:Int;

	public var slotSprites:Map<Int, Sprite> = new Map<Int, Sprite>();
	public var activeSlotSprites:Map<Int, Sprite> = new Map<Int, Sprite>();
	public var ammo:Map<Int, Text> = new Map<Int, Text>();

	public function new() {
		super();
		initHealthBar();
		initScore();
		initSlots();
		if (GlobalGameData.hud != null && !(GlobalGameData.currentLevel is Level1)) {
			this.activeSlot = GlobalGameData.hud.activeSlot;
			updateHealthBar();
			updateScore(GlobalGameData.playerEntity.player.score);
			for (i in 1...5) {
				slotSprites.get(i).visible = GlobalGameData.hud.slotSprites.get(i).visible;
				activeSlotSprites.get(i).visible = GlobalGameData.hud.activeSlotSprites.get(i).visible;
				if (GlobalGameData.hud.ammo.get(i).text != null) {
					updateAmmo(i, Std.parseInt(GlobalGameData.hud.ammo.get(i).text));
				}
			}
			GlobalGameData.hud.removeFromParent();
			GlobalGameData.hud.destroy();
		}
		GlobalGameData.hud = this;
	}

	function initHealthBar() {
		healthBar = new RectangleDisplay();
		healthBar.x = 50;
		healthBar.y = 50;
		healthBar.scaleX = maxHealth;
		healthBar.scaleY = 20;
		healthBar.setColor(255, 255, 255);
		healthBar.smooth = true;
		this.addChild(healthBar);
	}

	function initScore() {
		scoreText = new Text("RussoOne_Regular");
		scoreText.x = GlobalGameData.screenWidth - 200;
		scoreText.y = 50;
		scoreText.text = "Score: 0";
		this.addChild(scoreText);
	}

	function initSlots() {
		for (i in 1...5) {
			var name:String = "slot" + i;
			var sprite = new Sprite(name);
			slotSprites.set(i, sprite);
			sprite.scaleX = sprite.scaleY = 1;
			sprite.smooth = false;
			sprite.x = 40 + 100 * (i - 1);
			sprite.y = GlobalGameData.screenHeight - 100;
			sprite.visible = false;
			addChild(sprite);

			var ammoText:Text = new Text("RussoOne_Regular");
			ammoText.visible = false;
			ammo.set(i, ammoText);
			this.addChild(ammoText);
		}
		for (i in 1...5) {
			var name:String = "slot" + i + "Active";
			var sprite = new Sprite(name);
			activeSlotSprites.set(i, sprite);
			sprite.scaleX = sprite.scaleY = 1;
			sprite.smooth = false;
			sprite.x = 40 + 100 * (i - 1);
			sprite.y = GlobalGameData.screenHeight - 100;
			sprite.visible = false;
			addChild(sprite);
		}
	}

	public function selectSlot(number:Int) {
		if (activeSlot != number) {
			if (activeSlot != null) {
				activeSlotSprites.get(activeSlot).visible = false;
				slotSprites.get(activeSlot).visible = true;
			}
			slotSprites.get(number).visible = false;
			activeSlotSprites.get(number).visible = true;
			activeSlot = number;
		}
	}

	public function showSlot(number:Int, ammoCount:Int) {
		if (!activeSlotSprites.get(number).visible) {
			slotSprites.get(number).visible = true;
			updateAmmo(number, ammoCount);
		}
	}

	public function updateAmmo(number:Int, amount:Int) {
		var ammoText:Text = ammo.get(number);
		ammoText.text = "" + amount;
		ammoText.x = (40 + 100 * (number - 1)) + 40 - ammoText.width() * 0.5;
		ammoText.y = GlobalGameData.screenHeight - 130;
		ammoText.visible = true;
	}

	public function updateHealthBar() {
		if (healthBar.scaleX > 0 && GlobalGameData.playerEntity.player != null) {
			healthBar.scaleX = GlobalGameData.playerEntity.player.health;
		}
	}

	public function updateScore(newScore:Int) {
		scoreText.text = "Score: " + newScore;
	}
}
