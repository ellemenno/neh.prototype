package mteb.data
{
	import mteb.control.gamestate.IGameStateMachine;
	import mteb.data.config.IConfig;
	import mteb.data.input.IOrientationTransform;
	import mteb.data.map.IMap;
	import mteb.data.player.IInventory;
	import mteb.data.player.IStats;
	import mteb.data.time.ITime;


	public interface IDataLocator
	{
		function get config():IConfig;

		function get inventory():IInventory;

		function get look():IOrientationTransform;

		function get map():IMap;

		function get mcp():IGameStateMachine;

		function get stats():IStats;

		function get time():ITime;
	}
}
