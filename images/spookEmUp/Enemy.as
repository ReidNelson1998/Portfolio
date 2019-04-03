package
{
	import flash.display.MovieClip;
	import Particle;
	import flash.events.Event;	
	import flash.utils.*;
	
	public class Enemy extends Particle
	{
		public var status:String;
		
		public function Enemy()
		{
			status = "OK";
			xVel = 0;
			yVel = 0;
		}
		
		public function destroy():void
		{
			gotoAndPlay(9);
			status = "Dead";
			setTimeout(dispatch, 200);
		}
		
		public function dispatch():void
		{
			dispatchEvent(new Event(Particle.PURGE_EVENT, true, false));
		}
		
		public override function update():void
		{
			if (status != "Dead")
			{
				yVel = 0;
			}
			
			super.update();
			
			if (y > 490)
			{
				trace("spooky");
				dispatchEvent(new Event(Particle.PURGE_EVENT, true, false));
			}
		}
	}
}
