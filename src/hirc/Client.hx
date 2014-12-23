package hirc;
import haxe.Timer;
import sys.net.Host;
import sys.net.Socket;

using StringTools;

/**
 * ...
 * @author 
 */
class Client
{

	/**
	 * socket used by the class
	 */
	public var socket:Socket;
	public var nickname:String;
	
	public function new(host:String,port:Int,nickname:String) 
	{
		this.nickname;
		socket = new Socket();
		socket.connect(new Host(host), port);
		send('NICK $nickname');
		
		send('USER $nickname localhost localhost :$nickname');
	}
	
	public function tick()
	{
		var str = socket.input.readLine();
		trace("<" + str);
		if (str.startsWith("PING"))
		{
			send(str.replace("PING", "PONG"));
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
	
	public function sendMessage(channel:String,message:String):Void 
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
	
}