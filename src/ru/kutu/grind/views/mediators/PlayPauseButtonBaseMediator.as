package ru.kutu.grind.views.mediators  {
	
	import flash.events.MouseEvent;
	
	import org.osmf.events.PlayEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	
        import robotlegs.bender.framework.api.IInjector;

	import ru.kutu.grind.views.api.IPlayPauseButton;
        import ru.kutu.grind.config.PlayerConfiguration;
	import ru.kutu.grind.views.api.helpers.IVisible;
	
	public class PlayPauseButtonBaseMediator extends MediaControlBaseMediator {
		
		[Inject] public var view:IPlayPauseButton;
                [Inject] public var injector:IInjector;
		
		protected var playable:PlayTrait;
		
		private var _requiredTraits:Vector.<String> = new <String>[MediaTraitType.PLAY];
                protected var controlBarHidePlayPause:Boolean;
		
		override protected function get requiredTraits():Vector.<String> {
                        var configuration:PlayerConfiguration = injector.getInstance(PlayerConfiguration);
                        controlBarHidePlayPause = configuration.controlBarHidePlayPause;
			return _requiredTraits;
		}
		
		override protected function processRequiredTraitsAvailable(element:MediaElement):void {
			if (controlBarHidePlayPause) {
				view.enabled = false;
				view.visible = false;
			}
			else {
				view.enabled = true;
				addViewListener(MouseEvent.CLICK, onClick);
				if (element) {
					playable = element.getTrait(MediaTraitType.PLAY) as PlayTrait;
					playable.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
					onPlayStateChange();
				}
			}
		}
		
		override protected function processRequiredTraitsUnavailable(element:MediaElement):void {
			view.enabled = false;
			removeViewListener(MouseEvent.CLICK, onClick);
			if (playable) {
				playable.removeEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
				playable = null;
			}
		}
		
		protected function onPlayStateChange(event:PlayEvent = null):void {
			view.playState = playable.playState;
		}
		
		protected function onClick(event:MouseEvent):void {
			var playable:PlayTrait = media.getTrait(MediaTraitType.PLAY) as PlayTrait;
			if (playable.playState == PlayState.PLAYING && playable.canPause) {
				playable.pause();
			} else {
				playable.play();
			}
		}
		
	}
	
}
