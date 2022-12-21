// clang -fmodules roulette_hard.m -o /tmp/slsroulette -F /System/Library/PrivateFrameworks -framework SkyLight && /tmp/slsroulette

@import Foundation;

void SLSSetDebugOptions(int);

void l()
{
	int t=arc4random()%5;
	int a=0;
	for(int i=0;i<t;i++)
	{
		a|=1<<(arc4random()%16);
	}
	NSLog(@"get ready for %x...",a);
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,3*NSEC_PER_SEC),dispatch_get_main_queue(),^()
	{
		NSLog(@"%x is here!",a);
		SLSSetDebugOptions(a);
	});
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,10*NSEC_PER_SEC),dispatch_get_main_queue(),^()
	{
		l();
	});
}

int main()
{
	l();
	CFRunLoopRun();
}