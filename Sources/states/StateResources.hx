package states;

import com.loading.basicResources.SoundLoader;
import com.loading.basicResources.SpriteSheetLoader;
import com.loading.basicResources.TilesheetLoader;
import com.loading.basicResources.FontLoader;
import com.loading.basicResources.ImageLoader;
import com.loading.basicResources.JoinAtlas;
import com.loading.basicResources.DataLoader;
import com.loading.Resources;
import com.loading.Resource;

class StateResources {
	public static function attatch(resources:Resources, map:String) {
		var map:Resource = new DataLoader(map);

		var atlasMap = new JoinAtlas(2048, 2048);
		var atlasPlayer = new JoinAtlas(2048, 2048);
		var atlasEnemies = new JoinAtlas(1024, 1024);
		var atlasHUD = new JoinAtlas(1024, 1024);

		atlasHUD.add(new ImageLoader("slot1"));
		atlasHUD.add(new ImageLoader("slot2"));
		atlasHUD.add(new ImageLoader("slot3"));
		atlasHUD.add(new ImageLoader("slot4"));
		atlasHUD.add(new ImageLoader("slot1Active"));
		atlasHUD.add(new ImageLoader("slot2Active"));
		atlasHUD.add(new ImageLoader("slot3Active"));
		atlasHUD.add(new ImageLoader("slot4Active"));
		atlasHUD.add(new FontLoader("Kenney_Thick", 20));
		atlasHUD.add(new FontLoader("RussoOne_Regular", 32));

		atlasMap.add(new TilesheetLoader("tiles2", 32, 32, 0));
		atlasPlayer.add(new SpriteSheetLoader("soldierFlashlightSmall", 104, 81, 0, [
			new Sequence("attack", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]),
			new Sequence("idle", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34]),
			new Sequence("move", [35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54])
		]));
		atlasPlayer.add(new SpriteSheetLoader("soldierKnifeSmall", 96, 74, 0, [
			new Sequence("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]),
			new Sequence("attack", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]),
			new Sequence("move", [33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52])
		]));
		atlasPlayer.add(new SpriteSheetLoader("soldierPistolSmall", 103, 86, 0, [
			new Sequence("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]),
			new Sequence("move", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
			new Sequence("attack", [40, 41, 42])
		]));
		atlasPlayer.add(new SpriteSheetLoader("soldierAK47Small", 103, 68, 0, [
			new Sequence("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]),
			new Sequence("move", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
			new Sequence("attack", [40, 41, 42])
		]));
		atlasPlayer.add(new SpriteSheetLoader("soldierShotgunSmall", 100, 66, 0, [
			new Sequence("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]),
			new Sequence("move", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
			new Sequence("attack", [40, 41, 42])
		]));
		atlasEnemies.add(new SpriteSheetLoader("genericZombie", 32, 32, 0, [
			new Sequence("zombie1Down", [0, 1, 2]), new Sequence("zombie1Left", [12, 13, 14]), new Sequence("zombie1Right", [24, 25, 26]),
			new Sequence("zombie1Up", [36, 37, 38]), new Sequence("zombie2Down", [3, 4, 5]), new Sequence("zombie2Left", [15, 16, 17]),
			new Sequence("zombie2Right", [27, 28, 29]), new Sequence("zombie2Up", [39, 40, 41]), new Sequence("zombie3Down", [6, 7, 8]),
			new Sequence("zombie3Left", [18, 19, 20]), new Sequence("zombie3Right", [30, 31, 32]), new Sequence("zombie3Up", [42, 43, 44]),
			new Sequence("zombie4Down", [9, 10, 11]), new Sequence("zombie4Left", [21, 22, 23]), new Sequence("zombie4Right", [33, 34, 35]),
			new Sequence("zombie4Up", [45, 46, 47]), new Sequence("zombie5Down", [48, 49, 50]), new Sequence("zombie5Left", [60, 61, 62]),
			new Sequence("zombie5Right", [72, 73, 74]), new Sequence("zombie5Up", [84, 85, 86]), new Sequence("zombie6Down", [51, 52, 53]),
			new Sequence("zombie6Left", [63, 64, 65]), new Sequence("zombie6Right", [75, 76, 77]), new Sequence("zombie6Up", [87, 88, 89]),
			new Sequence("zombie7Down", [54, 55, 56]), new Sequence("zombie7Left", [66, 67, 68]), new Sequence("zombie7Right", [78, 79, 80]),
			new Sequence("zombie7Up", [90, 91, 92]), new Sequence("zombie8Down", [57, 58, 59]), new Sequence("zombie8Left", [69, 70, 71]),
			new Sequence("zombie8Right", [81, 82, 83]), new Sequence("zombie8Up", [93, 94, 95]),
		]));
		atlasEnemies.add(new SpriteSheetLoader("zombie1Small", 54, 58, 0, [
			new Sequence("attack", [0, 1, 2, 3, 4, 5, 6, 7, 8]),
			new Sequence("idle", [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25]),
			new Sequence("move", [26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42])
		]));

		resources.add(map);
		resources.add(atlasMap);
		resources.add(atlasPlayer);
		resources.add(atlasEnemies);
		resources.add(atlasHUD);

		resources.add(new SoundLoader("akUse"));
		resources.add(new SoundLoader("gunshotAK"));
		resources.add(new SoundLoader("gunshotPistol"));
		resources.add(new SoundLoader("gunshotSG"));
		resources.add(new SoundLoader("knifeAttack"));
		resources.add(new SoundLoader("knifeUse"));
		resources.add(new SoundLoader("pistolUse"));
		resources.add(new SoundLoader("punch"));
		resources.add(new SoundLoader("shotgunUse"));
	}
}
