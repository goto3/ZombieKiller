package states;

import entity.weapons.ShotgunEntity;
import entity.weapons.Ak47Entity;
import entity.weapons.PistolEntity;
import entity.consumibles.FirstAidEntity;
import com.soundLib.SoundManager.SM;
import com.loading.basicResources.SoundLoader;
import entity.DoorEntity;
import customCollisionEngine.CollisionGroup;
import entity.EnemyEntity;
import com.gEngine.display.Layer;
import format.tmx.Data.TmxTileLayer;
import format.tmx.Data.TmxObject;
import com.loading.Resources;
import customCollisionEngine.CollisionBox;
import customCollisionEngine.CollisionEngine;
import customCollisionEngine.Tilemap;
import entity.PlayerEntity;

class Level3 extends Level {
	public var winZone:CollisionBox;
	public var worldMap:Tilemap;

	var player:PlayerEntity = GlobalGameData.playerEntity;
	var enemyzone:TmxObject;

	public var door:DoorEntity;

	var time:Float = 0;
	var timeLastSpawn:Float = 0;

	public function new() {
		super();
	}

	override function load(resources:Resources) {
		StateResources.attatch(resources, "map3_tmx");
		resources.add(new SoundLoader("map3", false));
	}

	override function init() {
		GlobalGameData.currentLevel = this;
		GlobalGameData.enemyCollisionGroup = new CollisionGroup();

		GlobalGameData.simulationLayer = new Layer();
		stage.addChild(GlobalGameData.simulationLayer);

		worldMap = new Tilemap("map3_tmx", "tiles2");
		worldMap.init(parseTileLayers, parseMapObjects);
		GlobalGameData.worldMap = worldMap;

		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32, worldMap.heightInTiles * 32);
		GlobalGameData.camera = stage.defaultCamera();

		stage.addChild(new Hud());

		SM.playMusic("map3");
	}

	function parseTileLayers(layerTilemap:Tilemap, tileLayer:TmxTileLayer) {
		if (!tileLayer.properties.exists("noCollision")) {
			layerTilemap.createCollisions(tileLayer);
		}
		GlobalGameData.simulationLayer.addChild(layerTilemap.createDisplay(tileLayer));
	}

	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		if (compareName(object, "spawn")) {
			player = new PlayerEntity(object.x, object.y);
			addChild(player);
		} else if (compareName(object, "winZone")) {
			winZone = new CollisionBox();
			winZone.x = object.x;
			winZone.y = object.y;
			winZone.width = object.width;
			winZone.height = object.height;
		} else if (compareName(object, "enemyZone")) {
			enemyzone = object;
		} else if (compareName(object, "door")) {
			door = new DoorEntity(object.x, object.y - object.height);
			addChild(door);
		}
	}

	inline function compareName(object:TmxObject, name:String) {
		return object.name.toLowerCase() == name.toLowerCase();
	}

	override function update(dt:Float) {
		super.update(dt);
		time += dt;
		timeLastSpawn += dt;

		if (time < 90) {
			if (timeLastSpawn > 0.1) {
				timeLastSpawn = 0;
				spawnEnemy();
			}
		} else {
			var enemies = children.filter(f -> f is EnemyEntity);
			if (enemies.length == 0) {
				door.destroy();
			}
		}

		if (CollisionEngine.overlap(player.collision, winZone)) {
			changeState(new GameOverState(GlobalGameData.playerEntity.player.score, true));
		}
	}

	function spawnEnemy() {
		var random:Float = Std.random(100) + 1;
		if (random < 70) {
			var x = Std.random(Math.floor(enemyzone.width)) + Math.floor(enemyzone.x);
			var y = Std.random(Math.floor(enemyzone.height)) + Math.floor(enemyzone.y);
			var enemy:EnemyEntity = new EnemyEntity("genericZombie", x, y, true);
			addChild(enemy);
		} else {
			var x = Std.random(Math.floor(enemyzone.width)) + Math.floor(enemyzone.x);
			var y = Std.random(Math.floor(enemyzone.height)) + Math.floor(enemyzone.y);
			var enemy:EnemyEntity = new EnemyEntity("zombie1", x, y, true);
			addChild(enemy);
		}
	}

	public override function spawnRandomItem(x:Float, y:Float) {
		var random = Std.random(100) + 1;
		if (0 < random && random <= 40) {
			addChild(new FirstAidEntity(x, y));
		} else if (40 < random && random <= 70) {
			addChild(new PistolEntity(x, y));
		} else if (70 < random && random <= 90) {
			addChild(new Ak47Entity(x, y));
		} else if (90 < random && random <= 100) {
			addChild(new ShotgunEntity(x, y));
		}
	}

	public override function playerDeath() {
		super.playerDeath();
	}

	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
	}
	#end
}
