package hirc;
import haxe.Timer;
import hirc.Client.Message;
import neko.vm.Thread;
import sys.net.Host;
import sys.net.Socket;

using StringTools;

/**
 * ...
 * @author 
 */

 typedef Message = {
	parsed:Bool,
	raw:String,
	?sender:String,
	?command:String,
	?params:String,
	?content:String
 }
 
class Client
{

	private var socket:Socket;
	public var nickname:String;
	public var onMessage:Message->Void;
	
	public function new(host:String,port:Int,nickname:String,?autoTick:Bool=true) 
	{
		this.nickname = nickname;
		
		socket = new Socket();
		socket.connect(new Host(host), port);
		identify(nickname);
		
		if (autoTick)
		{
			var t = Thread.create(function () {
				while (true)
					tick();
			});
		}
	}
	
	public function tick()
	{
		var selected = Socket.select([socket], null, null, 0.016);
		if (selected.read.length > 0)
		{
			var str = selected.read[0].input.readLine();

			
			var message = parseMessage(str);
			//trace('sender:${message.sender}');
			//trace('command:${message.command}');
			//trace('params:${message.params}');
			//trace('content:${message.content}');
			
			if (onMessage != null)
				onMessage(message);			
			
			if (str.startsWith("PING"))
			{
				send(str.replace("PING", "PONG"));
			}
		}
	}
	
	public function parseMessage(msg:String):Message
	{
		//test it here: https://www.regex101.com/r/wK9qK2/6
		var exp = ~/^(?:[:](\S+)?)? ?(\S+) ([^ :]*)? *:?(.*)$/i;
		
		if (exp.match(msg))
		{
			return {
				parsed: true,
				raw:msg,
				sender : exp.matched(1),
				command : exp.matched(2),
				params : exp.matched(3),
				content : exp.matched(4),
			}
		}
		return {
			parsed:false,
			raw:msg,
		}
	}
	
	public function send(message:String)
	{
		trace(">>" + message);
		socket.output.writeString(message+"\r\n");
		socket.output.flush();
	}
	
	public function joinChannel(channelName:String):Void 
	{
		channelName = addHashSymbol(channelName);
		send('JOIN $channelName');
	}
	
	public function sendToChannel(channel:String,message:String):Void 
	{
		channel = addHashSymbol(channel);
		send('PRIVMSG $channel : $message');
	}
	
	public function sendPrivateMessage(user:String,message:String):Void 
	{
		send('PRIVMSG $user : $message');
	}
	
	function addHashSymbol(channelName:String):String 
	{
		if (channelName.charAt(0) != "&" &&
			channelName.charAt(0) != "#" &&
			channelName.charAt(0) != "+" &&
			channelName.charAt(0) != "!")
		{
			channelName = "#" + channelName;
		}
		return channelName;
	}
	
	function identify(nickname:String):Void 
	{
		send('NICK $nickname');
		
		send('USER $nickname localhost localhost :$nickname');
	}
	
}