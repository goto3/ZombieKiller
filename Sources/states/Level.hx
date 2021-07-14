package states;

import com.framework.utils.State;
import com.loading.Resources;

class Level extends State {
	public function new() {
		super();
	}

	override function load(resources:Resources) {}

	override function init() {}

	override function update(dt:Float) {
		super.update(dt);

		var player = GlobalGameData.playerEntity;
		var centerPlayerX = player.collision.x + player.collision.width * 0.5;
		var centerPlayerY = player.collision.y + player.collision.height * 0.5;
		stage.defaultCamera().setTarget(centerPlayerX, centerPlayerY);
	}

	public function playerDeath() {
		changeState(new GameOverState(GlobalGameData.playerEntity.player.score));
	}

	public function spawnRandomItem(x:Float, y:Float) {}

	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera = stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer, camera);
	}
	#end
}
