package ru.kutu.grind.views.api {
	
	import ru.kutu.grind.views.api.helpers.IEnabled;
	import ru.kutu.grind.views.api.helpers.IVisible;
	
	public interface IPlayPauseButton extends IEnabled, IVisible {
		
		function set playState(value:String):void;
		
	}
	
}
