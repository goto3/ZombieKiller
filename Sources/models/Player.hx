package models;

import states.Level1;
import models.weapons.Flashlight.FlashLight;
import models.weapons.Weapon;
import models.weapons.Shotgun;
import models.weapons.Pistol;
import models.weapons.Knife;
import models.weapons.Ak47;
import states.GlobalGameData;

class Player {
	@:isVar public var health(get, set):Float;
	@:isVar public var score(get, set):Int = 0;

	public var activeSlot:Weapon;

	public var slotKnife:Knife;
	public var slotPistol:Pistol;
	public var slotAk47:Ak47;
	public var slotShotgun:Shotgun;

	public function new() {
		if (GlobalGameData.playerEntity != null && !(GlobalGameData.currentLevel is Level1)) {
			this.health = GlobalGameData.playerEntity.player.health;
			this.activeSlot = GlobalGameData.playerEntity.player.activeSlot;
			this.slotKnife = GlobalGameData.playerEntity.player.slotKnife;
			this.slotPistol = GlobalGameData.playerEntity.player.slotPistol;
			this.slotAk47 = GlobalGameData.playerEntity.player.slotAk47;
			this.slotShotgun = GlobalGameData.playerEntity.player.slotShotgun;
			this.score = GlobalGameData.playerEntity.player.score;
		} else {
			this.health = GlobalGameData.initialHealth;
			this.activeSlot = new FlashLight();
		}
	}

	function get_health() {
		return health;
	}

	function set_health(value) {
		if (value <= 0.0) {
			GlobalGameData.currentLevel.playerDeath();
		} else {
			this.health = Math.min(value, GlobalGameData.maxHealth);
			if (GlobalGameData.hud != null)
				GlobalGameData.hud.updateHealthBar();
		}
		return Math.min(value, GlobalGameData.maxHealth);
	}

	function get_score() {
		return score;
	}

	function set_score(value) {
		this.score = value;
		GlobalGameData.hud.updateScore(value);
		return value;
	}

	public function consumeKnife() {
		if (slotKnife == null) {
			slotKnife = new Knife();
			GlobalGameData.hud.showSlot(1, 0);
		}
	}

	public function consumePistol() {
		if (slotPistol == null) {
			slotPistol = new Pistol();
			GlobalGameData.hud.showSlot(2, slotPistol.totalAmmo);
		} else {
			slotPistol.totalAmmo += GlobalGameData.pistolPickupAmmo;
		}
	}

	public function consumeAk47() {
		if (slotAk47 == null) {
			slotAk47 = new Ak47();
			GlobalGameData.hud.showSlot(3, slotAk47.totalAmmo);
		} else {
			slotAk47.totalAmmo += GlobalGameData.ak47PickupAmmo;
		}
	}

	public function consumeShotgun() {
		if (slotShotgun == null) {
			slotShotgun = new Shotgun();
			GlobalGameData.hud.showSlot(4, slotShotgun.totalAmmo);
		} else {
			slotShotgun.totalAmmo += GlobalGameData.shotgunPickupAmmo;
		}
	}

	public function selectSlot(number:Int) {
		switch number {
			case 1:
				if (slotKnife != null) {
					activeSlot = slotKnife;
					GlobalGameData.hud.selectSlot(1);
				}
			case 2:
				if (slotPistol != null) {
					activeSlot = slotPistol;
					GlobalGameData.hud.selectSlot(2);
				}
			case 3:
				if (slotAk47 != null) {
					activeSlot = slotAk47;
					GlobalGameData.hud.selectSlot(3);
				}
			case 4:
				if (slotShotgun != null) {
					activeSlot = slotShotgun;
					GlobalGameData.hud.selectSlot(4);
				}
		}
		GlobalGameData.playerEntity.createSprite();
	}
}
