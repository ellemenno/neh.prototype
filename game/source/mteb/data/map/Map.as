package mteb.data.map
{
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ProtectedSignal;

	import mteb.command.SignalBus;
	import mteb.command.signals.NodeChanged;


	public class Map implements IMap
	{
		protected const nodeChanged:ProtectedSignal = new NodeChanged();

		protected const _currentNode:Node = new Node();
		protected var xml:XML;


		public function Map()
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(nodeChanged as ISignal);
		}

		public function get currentNode():Node  { return _currentNode; }

		public function load(file:String):void
		{
			xml = <map startNode="001" startAzimuth="51.5">
					<node id="001" color="0x349000"/>
					<node id="002" color="0x0000fe"/>
					<node id="003" color="0xfe0000"/>
					<node id="004" color="0x00fe00"/>
					<node id="005" color="0xfe4600"/>
					<node id="006" color="0xfe00fe"/>
					<node id="007" color="0xfefe00"/>
					<node id="008" color="0x6000fe"/>
					<node id="009" color="0xfe006b"/>
					<node id="010" color="0x00fefe"/>
					<node id="011" color="0x9c00fe"/>
					<node id="012" color="0x6dc179"/>
					<node id="013" color="0xfd8d00"/>
					<node id="014" color="0x0077fe"/>
					<node id="015" color="0x9ffe00"/>
				</map>;

			onMapLoaded(); // TODO: load map externally, and set onMapLoaded as complete handler
		}

		public function triggerAction(trigger:ActionTrigger):void
		{
			var actionType:ActionTypeEnum = ActionTypeEnum.NONE;
			var jumpId:String;

			if (trigger.hotSpotColor != 0x000000)
			{
				jumpId = getNodeByColor(trigger.hotSpotColor);
				if (jumpId)
					actionType = ActionTypeEnum.JUMP_TO_NODE;
			}
			debug(this, "triggerAction() - {0} : {1} (jumpId: {2})", trigger, actionType, jumpId);

			switch (actionType)
			{
				case ActionTypeEnum.JUMP_TO_NODE:
					changeNode(jumpId);
					break;
			}
		}

		protected function changeNode(nodeId:String, azimuth:Number = 51.5):void
		{
			_currentNode.setId(nodeId);
			_currentNode.azimuth = azimuth;

			debug(this, "changeNode() - updated current node to: {0}; sending NodeChanged signal..", _currentNode);
			nodeChanged.send(this);
		}

		protected function getNodeByColor(color:uint):String
		{
			var nodeId:String;
			const nodeList:XMLList = xml.node;
			const n:uint = nodeList.length();
			for (var i:uint = 0; i < n; i++)
			{
				if (isApproximateMatch(color, parseInt(nodeList[i].@color)))
				{
					nodeId = nodeList[i].@id;
					break;
				}
			}

			debug(this, "getNodeByColor() - {0} -> {1}", uintToString(color), nodeId);
			return nodeId;
		}

		protected function getStartAzimuth():Number
		{
			return parseFloat(xml.@startAzimuth);
		}

		protected function getStartNode():String
		{
			return xml.@startNode;
		}

		protected function isApproximateMatch(a:uint, b:uint, fuzz:uint = 3):Boolean
		{
			if (a == b)
				return true;

			const ra:int = (a >> 16) & 0xff;
			const rb:int = (b >> 16) & 0xff;
			if (Math.abs(ra - rb) > fuzz)
				return false;

			const ga:int = (a >> 8) & 0xff;
			const gb:int = (b >> 8) & 0xff;
			if (Math.abs(ga - gb) > fuzz)
				return false;

			const ba:int = a & 0xff;
			const bb:int = b & 0xff;
			if (Math.abs(ba - bb) > fuzz)
				return false;

			return true;
		}

		protected function onMapLoaded():void
		{
			changeNode(getStartNode(), getStartAzimuth());
		}

		protected function uintToString(value:uint):String
		{
			const r:uint = (value >> 16) & 0xff;
			const g:uint = (value >> 8) & 0xff;
			const b:uint = value & 0xff;

			const rx:String = ((r < 16) ? "0" : "") + r.toString(16);
			const gx:String = ((g < 16) ? "0" : "") + g.toString(16);
			const bx:String = ((b < 16) ? "0" : "") + b.toString(16);

			return "0x" + rx + gx + bx;
		}
	}
}
