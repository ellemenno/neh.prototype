package mteb.view.scene.compass
{


	public class CompassLightEnum
	{
		public static const LOCKED:CompassLightEnum = new CompassLightEnum("LOCKED");
		public static const UNLOCKED:CompassLightEnum = new CompassLightEnum("UNLOCKED");
		public static const CAPTURED:CompassLightEnum = new CompassLightEnum("CAPTURED");

		private var label:String;


		public function CompassLightEnum(label:String)
		{
			this.label = label;
		}

		public function toString():String
		{
			return label;
		}
	}
}