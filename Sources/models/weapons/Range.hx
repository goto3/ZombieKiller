package models.weapons;

class Range extends Weapon {
	public function new() {
		super();
	}

	public function get_totalAmmo() {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function get_bulletSpeed():Int {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function get_bulletWidth():Int {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function get_bulletHeight():Int {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function get_bulletDamage():Int {
		throw new haxe.exceptions.NotImplementedException();
	}
}
