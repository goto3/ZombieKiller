package states;

import com.soundLib.SoundManager.SM;
import com.loading.basicResources.SoundLoader;
import entity.weapons.PistolEntity;
import entity.weapons.KnifeEntity;
import entity.consumibles.FirstAidEntity;
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

class Level1 extends Level {
	public var winZone:CollisionBox;
	public var worldMap:Tilemap;

	var player:PlayerEntity;
	var enemyzones:Array<TmxObject> = new Array<TmxObject>();
	var randomItems:Array<TmxObject> = new Array<TmxObject>();

	public function new() {
		super();
	}

	override function load(resources:Resources) {
		StateResources.attatch(resources, "map1_tmx");
		resources.add(new SoundLoader("map1", false));
	}

	override function init() {
		GlobalGameData.currentLevel = this;
		GlobalGameData.enemyCollisionGroup = new CollisionGroup();

		GlobalGameData.simulationLayer = new Layer();
		stage.addChild(GlobalGameData.simulationLayer);

		worldMap = new Tilemap("map1_tmx", "tiles2");
		worldMap.init(parseTileLayers, parseMapObjects);
		GlobalGameData.worldMap = worldMap;

		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32, worldMap.heightInTiles * 32);
		GlobalGameData.camera = stage.defaultCamera();

		stage.addChild(new Hud());

		spawnEnemies();

		SM.playMusic("map1");
	}

	function spawnEnemies() {
		for (zone in enemyzones) {
			var count1 = Std.parseInt(zone.properties.get("generic"));
			for (i in 0...count1) {
				var x = Std.random(Math.floor(zone.width)) + Math.floor(zone.x);
				var y = Std.random(Math.floor(zone.height)) + Math.floor(zone.y);
				var enemy:EnemyEntity = new EnemyEntity("genericZombie", x, y);
				addChild(enemy);
			}
			var count2 = Std.parseInt(zone.properties.get("zombie1"));
			for (i in 0...count2) {
				var x = Std.random(Math.floor(zone.width)) + Math.floor(zone.x);
				var y = Std.random(Math.floor(zone.height)) + Math.floor(zone.y);
				var enemy:EnemyEntity = new EnemyEntity("zombie1", x, y);
				addChild(enemy);
			}
		}
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
		} else if (compareName(object, "hp")) {
			addChild(new FirstAidEntity(object.x, object.y - object.height));
		} else if (compareName(object, "knife")) {
			addChild(new KnifeEntity(object.x, object.y - object.height));
		} else if (compareName(object, "pistol")) {
			addChild(new PistolEntity(object.x, object.y - object.height));
		} else if (compareName(object, "enemyZone")) {
			enemyzones.push(object);
		}
	}

	inline function compareName(object:TmxObject, name:String) {
		return object.name.toLowerCase() == name.toLowerCase();
	}

	override function update(dt:Float) {
		super.update(dt);

		if (CollisionEngine.overlap(player.collision, winZone)) {
			changeState(new Level2());
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
