package customCollisionEngine;

import kha.math.FastVector2;
import customCollisionEngine.Body;
import customCollisionEngine.CollisionType;
import customCollisionEngine.ICollider;
import customCollisionEngine.CollisionGroup;

class CollisionCircle extends Body implements ICollider {
	public var radius:Float = 0;
	public var mass:Float = 100;
	public var userData:Dynamic;
	public var parent:CollisionGroup;

	public function new(radius) {
		super();
		this.radius = radius;
		this.mass = Math.PI * radius * radius;
	}

	public function collide(aCollider:ICollider, ?NotifyCallback:ICollider->ICollider->Void):Bool {
		if (aCollider == this)
			return false;
		if (overlapVsCircle(aCollider)) {
			var circle:CollisionCircle = cast aCollider;
			var c1:FastVector2 = new FastVector2(circle.x + circle.radius, circle.y + circle.radius);
			var c2:FastVector2 = new FastVector2(this.x + this.radius, this.y + this.radius);
			var n:FastVector2 = c2.sub(c1).normalized();
			var p:Float = 2 * (circle.lastVelocityX * n.x + circle.lastVelocityY * n.y - this.lastVelocityX * n.x - this.lastVelocityY * n.y) / (circle.mass
				+ this.mass);
			if (p > 0) {
				circle.velocityX = circle.lastVelocityX - p * this.mass * n.x;
				circle.velocityY = circle.lastVelocityY - p * this.mass * n.y;
				this.velocityX = this.lastVelocityX + p * circle.mass * n.x;
				this.velocityY = this.lastVelocityY + p * circle.mass * n.y;
				return true;
			}
		} // TODO if(overlapVsBox) collide
		return false;
	}

	public function overlap(collider:ICollider, ?notifyCallback:ICollider->ICollider->Void):Bool {
		if (collider == this)
			return false;
		var overlap:Bool = overlapVsCircle(collider) || overlapVsBox(collider);
		if (overlap && notifyCallback != null)
			notifyCallback(this, collider);
		return overlap;
	}

	public function collisionType():CollisionType {
		return CollisionType.Circle;
	}

	public function removeFromParent():Void {
		if (parent != null) {
			parent.remove(this);
		}
	}

	function overlapVsCircle(collider:ICollider):Bool {
		if (collider.collisionType() == CollisionType.Circle) {
			var circle:CollisionCircle = cast collider;
			var c1:FastVector2 = new FastVector2(circle.x + circle.radius, circle.y + circle.radius);
			var c2:FastVector2 = new FastVector2(this.x + this.radius, this.y + this.radius);
			return (c1.sub(c2).length <= circle.radius + radius);
		}
		return false;
	}

	function overlapVsBox(collider:ICollider):Bool {
		if (collider.collisionType() == CollisionType.Box) {
			var box:CollisionBox = cast collider;
			var boxVerticeX:Float = 0;
			var boxVerticeY:Float = 0;
			if (this.x < box.x)
				boxVerticeX = box.x;
			else
				boxVerticeX = box.x + box.width;
			if (this.y < box.y)
				boxVerticeY = box.y;
			else
				boxVerticeY = box.y + box.height;

			var distX:Float = this.x + this.radius - boxVerticeX;
			var distY:Float = this.y + this.radius - boxVerticeY;
			var distance:Float = Math.sqrt((distX * distX) + (distY * distY));

			return (distance <= this.radius);
		}
		return false;
	}

	#if DEBUGDRAW
	public function debugDraw(canvas:kha.Canvas):Void {
		var g2 = canvas.g2;
		var iterations = Std.int(radius);
		var angle = Math.PI * 2 / iterations;

		for (i in 0...iterations) {
			g2.drawLine(x
				+ Math.cos(angle * i) * radius
				+ radius, y
				+ Math.sin(angle * i) * radius
				+ radius, x
				+ Math.cos(angle * (i + 1)) * radius
				+ radius,
				y
				+ Math.sin(angle * (i + 1)) * radius
				+ radius);
		}
	}
	#end
}
