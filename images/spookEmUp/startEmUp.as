package
{
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import spookEmUpBase;
	
	public class startEmUp extends MovieClip
	{
		public function startEmUp()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			createStartMenu();
		}
		
		private function createStartMenu():void
		{
			var startMenu:StartScreen = new StartScreen();
			
			startMenu.width = 600;
			startMenu.height = 875;
			startMenu.x = 274;
			startMenu.y = 200;
			
			addChild(startMenu);
			
			startMenu.startButton.addEventListener(MouseEvent.CLICK, startGameHandler);
		}
		
		private function startGameHandler(evt:MouseEvent):void
		{
			removeChild(evt.currentTarget.parent);
			
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startGameHandler);
			
			createGame();
		}
		
		private function createGame():void
		{
			var game:spookEmUpBase = new spookEmUpBase();
			
			addChild(game);
		}
	}
}