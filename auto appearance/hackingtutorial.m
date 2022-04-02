void SLSSetAppearanceThemeSwitchesAutomatically(int edi)
{
	trace(@"SLSSetAppearanceThemeSwitchesAutomatically %d",edi);
	
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"moraea.appearance" object:nil userInfo:@{@"switches":[NSNumber numberWithInt:edi]}];
}