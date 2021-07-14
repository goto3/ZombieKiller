package helpers;

import customCollisionEngine.CollisionBox;
import kha.math.FastVector2;
import states.GlobalGameData;
import com.framework.utils.Input;

class Helpers {
	public static inline function getFacingDir(collision:CollisionBox):FastVector2 {
		if (collision != null) {
			var x:Float = collision.x + collision.width * 0.5;
			var y:Float = collision.y + collision.height * 0.5;
			var mousePosition = GlobalGameData.camera.screenToWorld(Input.i.getMouseX(), Input.i.getMouseY());
			return new FastVector2(mousePosition.x - x, mousePosition.y - y).normalized();
		}
		return null;
	}
}
