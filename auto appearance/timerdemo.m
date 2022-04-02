// clang -fmodules timerdemo.m -o timerdemo && ./timerdemo

@import Foundation;

int main()
{
	NSDate* fire=[NSDate dateWithTimeIntervalSinceNow:5]; // i guess you'll have to do a bit of math for this
	NSTimeInterval repeat=/*24*60*60*/5; // a day or whatever
	NSTimer* timer=[NSTimer.alloc initWithFireDate:fire interval:repeat repeats:true block:^(NSTimer* timer)
	{
		NSLog(@"hi");
		// do stuff
	}];
	
	[NSRunLoop.currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
	
	// don't put this in if it's a plugin
	NSRunLoop.currentRunLoop.run;
}