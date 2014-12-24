package;

import hirc.Client;
import sys.io.File;
import sys.net.Host;
import sys.net.Socket;

using StringTools;

/**
 * ...
 * @author 
 */

class Main 
{
	static private var client:hirc.Client;
	
	static function main() 
	{
		

		client = new Client("irc.freenode.net", 6667, "haxe-client");
		client.onMessage = function (message:Message) {
			if (message.parsed)
			{
				trace(message.content);
				if (message.command.toUpperCase() == "PRIVMSG")
				{
					writeToLog(message);
				}
			}
			
		};
		client.joinChannel("#haxe-client-testing");
		client.sendToChannel("haxe-client-testing", "this is a test using threads");
		
		while (true)
		{
			var message = Sys.stdin().readLine();
			client.send(message);
		};
	}
	
	static private function writeToLog(message:Message) 
	{
		//trace('${message.params} | ${message.sender}: ${message.content}');
		var filename:String;
		trace('${message.params}==${client.nickname}  :  ${message.params == client.nickname}');
		if (message.params == client.nickname)
		{
			filename = message.sender.substr(0, message.sender.indexOf("!"));
		}else {
			filename = message.params;
		}

		
		quickAppend('logs/$filename.txt','${message.sender}:${message.content}\n');	
	}
	
	static private function quickAppend(file:String,content:String):Void 
	{
		var f = File.append(file);
		f.writeString(content);
		f.close();
	
	}
	
}