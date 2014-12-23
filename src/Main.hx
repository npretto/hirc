package;

import hirc.Client;
import sys.net.Host;
import sys.net.Socket;

/**
 * ...
 * @author 
 */

class Main 
{
	
	static function main() 
	{
		var client = new Client("irc.freenode.net", 6667, "haxe-client");
		client.joinChannel("#reddit-gamdev");
		client.sendMessage("lordkryss", "this is a test");
		//client.sendMessage("#0x", "hi k00pa!");
		//client.sendMessage("0x", "boobs?");
		while (true)
		{
			client.tick();
		}
		//var client = new Client("127.0.0.1",1337,"lordkryss");
		var tcp = client.socket;
		//while (true)
		//{
			//var str = tcp.input.readLine();
			//trace(">"+str);
			//
		//}
		
	}
	
}