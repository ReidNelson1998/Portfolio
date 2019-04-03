package {
	
	import flash.display.MovieClip
	import flash.geom.Point;
	import flash.events.*;
	import flash.display.Sprite;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import com.greensock.*;
	import com.greensock.easing.*;
	import Particle;
	import Enemy;


	public class spookEmUpBase extends MovieClip {
		public var vx: int;
		public var vy: int;
		private var bullets: Array;
		private var skulls: Array;
		private var touchLayer: Sprite;
		private var background: Sprite;
		private var thisBack1: spookBackground = new spookBackground();
		private var thisBack2: spookBackground = new spookBackground();
		private var player: spook;
		private var board: scoreboard;
		private var hp: healthbar;
		private var particleLayer: Sprite;
		private var enemyLayer: Sprite;
		private var skullNum: int;
		private var _backfactor: Number = 0.2;
		private var _speed: Number = 0.2;
		private var timer: Timer;
		private var timer2: Timer;
		private var scoreText: TextField;
		private var score: uint;
		private var healthText: TextField;
		private var health: uint;

		public function spookEmUpBase() {
			makeLevelOne();
			
			vx = 0;
			vy = 0;
			
			skulls = new Array();
			bullets = new Array();

			addEventListener(Event.ENTER_FRAME, update);

			touchLayer = new Sprite();

			addChild(touchLayer);
			addEventListener(Event.ADDED_TO_STAGE, setupTouchLayer);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ENTER_FRAME, Framing);
		}

		private function DownKey(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.LEFT) {
				player.gotoAndPlay(7);
				vx = -10;
			} else if (event.keyCode == Keyboard.RIGHT) {
				player.gotoAndPlay(12);
				vx = 10;
			} else if (event.keyCode == Keyboard.UP) {
				vy = -10;
			} else if (event.keyCode == Keyboard.DOWN) {
				vy = 10;
			}

		}
		private function UpKey(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT) {
				player.gotoAndPlay(1);
				vx = 0;
			} else if (event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.UP) {
				vy = 0;
			}
		}
		private function Fire(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.Z) {
				spawnBullet();
			}
		}
		private function onEnterFrame(event: Event): void {
			player.x += vx;
			player.y += vy;
		}
		private function Framing(event: Event): void {
			var playerHalfWidth: Number = player.width / 2;
			var playerHalfHeight: Number = player.height / 2;

			if (player.x + playerHalfWidth > stage.stageWidth) {

				player.x = stage.stageWidth - playerHalfWidth;
			} else if (player.x - playerHalfWidth < 0) {
				player.x = 0 + playerHalfWidth;
			}

			if (player.y - playerHalfHeight < 0) {
				player.y = 0 + playerHalfHeight;
			} else if (player.y + playerHalfHeight > stage.stageHeight) {
				player.y = stage.stageHeight - playerHalfHeight;
			}
		}
		private function setupTouchLayer(evt: Event): void {
			touchLayer.graphics.beginFill(0x000000, 0);
			touchLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			touchLayer.graphics.endFill();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, DownKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, UpKey);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, Fire);

			player.width = 27;
			player.height = 36;
			player.x = 225;
			player.y = 350;

		}
		private function makeLevelOne(): void {
			player = new spook();
			background = new spookBackground();
			board = new scoreboard();
			hp = new healthbar();

			addChild(background);

			thisBack1.x = -5;
			thisBack1.y = -526.95;
			background.addChild(thisBack1);

			thisBack2.x = -5;
			thisBack2.y = -526.95;
			background.addChild(thisBack2);
			addEventListener(Event.ENTER_FRAME, parallax, false, 0, true);

			enemyLayer = new Sprite;
			background.addChild(enemyLayer);

			particleLayer = new Sprite;
			background.addChild(particleLayer);

			background.addChild(player);
			
			board.x = 530;
			board.y = 30;
			background.addChild(board);
			
			hp.x = 10;
			hp.y = 380;
			hp.width = 80;
			hp.height = 80;
			background.addChild(hp);

			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, spawnEnemy);
			timer.start();
			timer2 = new Timer(2300);
			timer2.addEventListener(TimerEvent.TIMER, spawnEnemy);
			timer2.start();

			scoreText = new TextField();
			scoreText.x = 520;
			scoreText.y = 10;
			scoreText.width = 200;
			background.addChild(scoreText);
			scoreText.textColor = 0xffffff;
			scoreText.text;
			
			healthText = new TextField();
			healthText.x = 30;
			healthText.y = 375;
			healthText.width = 200;
			background.addChild(healthText);
			healthText.textColor = 0xffffff;
			healthText.text;
			health += 250;
			healthText.text = health.toString();
		}
		private function spawnEnemy(event: TimerEvent): void {

			var i: int;
			for (i = 0; i < 1; i++) {
				var newSkull = new Skull();

				newSkull.x = Math.random() * background.width - 100;
				newSkull.y = 0;
				newSkull.width = 30;
				newSkull.height = 30;

				TweenLite.to(newSkull, 3, {
					x: Math.random() * background.width - 100,
					y: 500,
					ease: Linear.easeNone
				});

				newSkull.addEventListener(Particle.PURGE_EVENT, purgeSkullHandler);

				enemyLayer.addChild(newSkull);

				skulls.push(newSkull);
			}
			rip();
			success();
		}
		private function spawnBullet(): void {
			var i: int;
			for (i = 0; i < 5; i++) {
				var newBullet = new Bullet();

				newBullet.x = player.x;
				newBullet.y = player.y;
				newBullet.width = 10;
				newBullet.height = 10;
				newBullet.vy = 100;

				TweenLite.to(newBullet, 1, {
					x: player.x,
					y: player.y - 400,
					ease: Linear.easeNone
				});
			}
			newBullet.addEventListener(Particle.PURGE_EVENT, purgeBulletHandler);
			particleLayer.addChild(newBullet);
			bullets.push(newBullet);
		}

		private function purgeSkullHandler(evt: Event): void {
			var targetSkull: Particle = Particle(evt.target);
			purgeSkull(targetSkull);
		}

		private function purgeSkull(targetSkull: Particle): void {
			targetSkull.removeEventListener(Particle.PURGE_EVENT, purgeSkullHandler);
			try {
				var i: int;
				for (i = 0; i < skulls.length; i++) {
					if (skulls[i].name == targetSkull.name) {
						skulls.splice(i, 1);
						enemyLayer.removeChild(targetSkull);
						i = skulls.length;
					}
				}
			} catch (e: Error) {
				trace("Failed to delete skull!", e);
			}
		}

		private function purgeBulletHandler(evt: Event): void {
			var targetBullet: Particle = Particle(evt.target);
			purgeBullet(targetBullet);
		}

		private function purgeBullet(targetBullet: Particle): void {
			targetBullet.removeEventListener(Particle.PURGE_EVENT, purgeBulletHandler);
			try {
				var i: int;
				for (i = 0; i < bullets.length; i++) {
					if (bullets[i].name == targetBullet.name) {
						bullets.splice(i, 1);
						particleLayer.removeChild(targetBullet);
						i = bullets.length;
					}
				}
			} catch (e: Error) {
				trace("Failed to delete bullet!", e);
			}
		}

		private function parallax(event: Event) {
			var movement: Number = -(player.y - (stage.stageHeight)) * _speed;

			thisBack1.y += movement * _backfactor;
			thisBack2.y += movement * _backfactor;

			align(thisBack1, thisBack2);
		}

		private function align(clip1: MovieClip, clip2: MovieClip) {
			if (clip1.y < 0 && clip2.y < 0) {
				if (clip1.y > clip2.y) {
					clip2.y = clip1.y = clip1.height;
				} else {
					clip1.y = clip2.y + clip2.height;
				}
			} else if (clip1.y > 0 && clip2.y > 0) {
				if (clip1.y < clip2.y) {
					clip2.y = clip1.y - clip1.height;
				} else {
					clip1.y = clip2.y - clip2.height;
				}
			}
		}

		private function hitTest(bullet: Particle): void {
			for each(var newSkull: Skull in skulls) {
				if (newSkull.status != "Dead" && newSkull.hitTestPoint(bullet.x, bullet.y)) {
					newSkull.destroy();
					purgeBullet(bullet);
					score += 100;
					scoreText.text = score.toString();
					health += 2;
					healthText.text = health.toString();
				}
			}
		}

		private function rip() {
			if (health > 100000) {
				timer.stop();
				timer2.stop();

				var i: int = this.numChildren;
				while (i--) {
					removeChildAt(i);
				}
				var end = new endScreen();
				end.x = 260;
				end.y = 200;
				addChild(end);
				
				scoreText.x = 225;
				scoreText.y = 300;
				addChild(scoreText);
				
				end.restartButton.addEventListener(MouseEvent.CLICK, startGameHandler);
			}
		}
		
		private function success() {
			if (score > 10000 && score < 100000) {
				timer.stop();
				timer2.stop();
				
				var i: int = this.numChildren;
				while (i--) {
					removeChildAt(i);
				}
				var win = new winScreen();
				win.x = 234;
				win.y = 225;
				win.width = 750;
				win.height = 500;
				addChild(win);
				
				win.restartButton.addEventListener(MouseEvent.CLICK, startGameHandler);
			}
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
	
		private function update(event: Event): void {

			for each(var newSkull: Particle in skulls) {
				newSkull.update();
				if (newSkull.y > 430) {
					//score -= 5;
					//scoreText.text = score.toString();
					health -= 1;
					healthText.text = health.toString();
				}
			}

			for each(var bullet: Particle in bullets) {
				bullet.update();
				hitTest(bullet);
			}
		}
	}
}