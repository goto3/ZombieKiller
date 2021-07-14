package states;

import customCollisionEngine.CollisionGroup;
import customCollisionEngine.Tilemap;
import entity.PlayerEntity;
import states.Hud;
import com.gEngine.display.Layer;
import com.gEngine.display.Camera;

class GlobalGameData {
	public static final screenWidth:Int = 1280;
	public static final screenHeight:Int = 720;

	// ################ World settings ################
	public static var worldMap:Tilemap;
	public static var simulationLayer:Layer;
	public static var currentLevel:Level;
	public static var camera:Camera;
	public static var hud:Hud;
	public static var playerEntity:PlayerEntity;
	public static var enemyCollisionGroup:CollisionGroup;

	// ################ Player settings ################
	public static final playerWidth:Int = 56;
	public static final playerHeight:Int = 48;
	public static final playerMoveSpeed:Float = 320;
	public static final scoreOnBulletHit:Int = 20;
	public static final scoreOnHit:Int = 50;

	// ################ Photon settings ################
	public static final photonWidth:Int = 1;
	public static final photonHeight:Int = 1;
	public static final photonSpeed:Float = 1500;

	// ################ Difficulty #####################
	public static final initialHealth:Int = 400;
	public static final maxHealth:Int = 1000;
	// GenericZombie
	public static final gzDamage:Int = 2;
	public static final gzAtkSpd:Int = 200; // greater = easier
	public static final gzRunSpd:Int = 200;
	// Zombie1
	public static final z1Damage:Int = 4;
	public static final z1AtkSpd:Int = 100; // greater = easier
	public static final z1RunSpd:Int = 300;

	// ################ Weapons ####################
	// Melee
	public static final meleeAtkSpd:Int = 400; // greater = slower
	public static final meleeDmg:Int = 50;
	public static final meleeRange:Int = 20;
	// Knife
	public static final knifeAtkSpd:Int = 300; // greater = slower
	public static final knifeDmg:Int = 100;
	public static final knifeRange:Int = 25;
	// Pistol
	public static final pistolAtkSpd:Int = 96; // greater = slower
	public static final pistolMaxAmmo:Int = 600;
	public static final pistolPickupAmmo:Int = 100;
	public static final pistolBulletDamage:Int = 25;
	public static final pistolBulletSpd:Int = 1000;
	public static final pistolBulletWidth:Int = 6;
	public static final pistolBulletHeight:Int = 2;
	// AK47
	public static final ak47AtkSpd:Int = 96;
	public static final ak47MaxAmmo:Int = 1200;
	public static final ak47PickupAmmo:Int = 120;
	public static final ak47BulletDamage:Int = 34;
	public static final ak47BulletSpd:Int = 1500;
	public static final ak47BulletWidth:Int = 6;
	public static final ak47BulletHeight:Int = 2;
	// Shotgun
	public static final shotgunAtkSpd:Int = 500;
	public static final shotgunMaxAmmo:Int = 200;
	public static final shotgunPickupAmmo:Int = 80;
	public static final shotgunPellets:Int = 30;
	public static final shotgunPelletDamage:Int = 20;
	public static final shotgunPelletSpd:Int = 800;
	public static final shotgunPelletWidth:Int = 2;
	public static final shotgunPelletHeight:Int = 2;
	// ################ Consumibles ####################
	public static final fakHealAmount:Int = 100;
}
