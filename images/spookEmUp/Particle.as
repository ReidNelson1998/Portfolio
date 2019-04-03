package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Particle extends MovieClip
	{
		public static const PURGE_EVENT:String = "PURGE";
		
		public var xVel:Number;
		public var yVel:Number;
		
		public function Particle()
		{
			xVel = 0;
			yVel = 0;
		}
		
		public function update():void
		{
			x += xVel;
			y += yVel;
			
			if (y < 0)
			{
				trace("Bullet Gone");
				dispatchEvent(new Event(Particle.PURGE_EVENT, true, false));
			}
		}
	}
}