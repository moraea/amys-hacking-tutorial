#define SWITCH_DEFAULTS @"moraea.appearance"

void SLSSetAppearanceThemeSwitchesAutomatically(BOOL edi)
{
	trace(@"SLSSetAppearanceThemeSwitchesAutomatically %d",edi);
	
	[NSUserDefaults.standardUserDefaults setBool:edi forKey:SWITCH_DEFAULTS];
	
	// as discussed we don't really need this
	// [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"moraea.appearance" object:nil userInfo:@{@"switches":[NSNumber numberWithInt:edi]}];
}

BOOL SLSGetAppearanceThemeSwitchesAutomatically()
{
	BOOL result=[NSUserDefaults.standardUserDefaults boolForKey:SWITCH_DEFAULTS];
	
	trace(@"SLSGetAppearanceThemeSwitchesAutomatically %d",result);
	
	return result;
}