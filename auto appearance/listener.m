// clang -fmodules listener.m -o listener && ./listener

@import Foundation;

int main()
{
	[NSDistributedNotificationCenter.defaultCenter addObserverForName:@"moraea.appearance" object:nil queue:nil usingBlock:^(NSNotification* note)
	{
		NSLog(@"notification %@",note);
		
		// do stuff with ((NSNumber*)note.userInfo[@"switches"]).boolValue
	}];
	
	CFRunLoopRun();
}