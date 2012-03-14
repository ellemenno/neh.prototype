package mteb.data
{
	import mteb.data.input.IOrientationTransform;
	import mteb.data.input.UserOrientationTransform;
	import mteb.data.map.IMap;
	import mteb.data.map.Map;
	import mteb.data.stats.IStats;
	import mteb.data.stats.Stats;
	import mteb.data.time.ITime;
	import mteb.data.time.Time;


	public class DataLocator implements IDataLocator
	{
		private static var instance:IDataLocator;

		public static function getInstance():IDataLocator
		{
			return instance || (instance = new DataLocator(new SingletonKey()));
		}

		private var _look:IOrientationTransform;

		private var _map:IMap;

		private var _stats:IStats;

		private var _time:ITime;


		public function DataLocator(key:SingletonKey)
		{
			if (!key)
				throw new ArgumentError(SingletonKey.ERROR_MSG);
		}

		public function get look():IOrientationTransform  { return _look || (_look = new UserOrientationTransform()); }

		public function get map():IMap  { return _map || (_map = new Map()); }

		public function get stats():IStats  { return _stats || (_stats = new Stats()); }

		public function get time():ITime  { return _time || (_time = new Time()); }
	}
}


internal class SingletonKey
{
	public static const ERROR_MSG:String = "Please do not instantiate directly, use the getInstance() method instead.";
}
