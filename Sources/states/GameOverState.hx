package states;

import kha.input.KeyCode;
import com.gEngine.display.Sprite;
import com.gEngine.display.Text;
import com.framework.utils.State;
import com.framework.utils.Input;
import com.loading.basicResources.ImageLoader;
import com.loading.basicResources.FontLoader;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;

class GameOverState extends State {
	var score:Int = 0;
	var win:Bool = false;

	public function new(score:Int, win:Bool = false) {
		super();
		this.score = score;
		this.win = win;
	}

	override function load(resources:Resources) {
		var atlas = new JoinAtlas(512, 512);
		atlas.add(new FontLoader("Kenney_Thick", 20));
		atlas.add(new ImageLoader("gameOver"));
		resources.add(atlas);
	}

	override function init() {
		if (win) {
			var winText = new Text("Kenney_Thick");
			winText.text = "CONGRATULATIONS YOU SURVIVED";
			winText.scaleX = 2;
			winText.scaleY = 2;
			winText.x = (GlobalGameData.screenWidth - winText.width() * winText.scaleX) * 0.5;
			winText.y = 280;
			stage.addChild(winText);
		} else {
			var image = new Sprite("gameOver");
			image.scaleX = 1.5;
			image.scaleY = 1.5;
			image.smooth = false;
			image.x = (GlobalGameData.screenWidth - image.width() * image.scaleX) * 0.5;
			image.y = 85;
			stage.addChild(image);
		}

		var textScore = new Text("Kenney_Thick");
		textScore.text = "Final Score    " + score;
		textScore.x = (GlobalGameData.screenWidth - textScore.width()) * 0.5;
		textScore.y = 480;
		stage.addChild(textScore);

		var textPlayAgain = new Text("Kenney_Thick");
		textPlayAgain.scaleX = 0.5;
		textPlayAgain.scaleY = 0.5;
		textPlayAgain.text = "Press SPACE to play again!";
		textPlayAgain.x = (GlobalGameData.screenWidth - textPlayAgain.width() * textPlayAgain.scaleX) * 0.5;
		textPlayAgain.y = 640;
		stage.addChild(textPlayAgain);
	}

	override function update(dt:Float) {
		super.update(dt);
		if (Input.i.isKeyCodePressed(KeyCode.Space)) {
			this.changeState(new Level1());
		}
	}
}
