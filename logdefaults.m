// clang -fmodules -dynamiclib -I ../non-metal-common/Utils logdefaults.m -o /tmp/defaults.dylib && codesign -fs - /tmp/defaults.dylib && DYLD_INSERT_LIBRARIES=/tmp/defaults.dylib /S*/A*/T*/C*/M*/TextEdit

#define showBacktrace false

#import "Utils.h"

NSMutableSet<NSString*>* seen=nil;

void takeKey(NSString* key)
{
	if(!seen)
	{
		seen=NSMutableSet.alloc.init;
	}
	
	if(![seen containsObject:key])
	{
		if(showBacktrace)
		{
			trace(@"%@ %@",key,NSThread.callStackSymbols);
		}
		else
		{
			trace(@"%@",key);
		}
		[seen addObject:key];
	}
}

id (*realValue)(NSUserDefaults*,SEL,NSString*);
id fakeValue(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realValue(self,sel,key);
}
id (*realObject)(NSUserDefaults*,SEL,NSString*);
id fakeObject(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realObject(self,sel,key);
}
NSURL* (*realURL)(NSUserDefaults*,SEL,NSString*);
NSURL* fakeURL(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realURL(self,sel,key);
}
NSArray* (*realArray)(NSUserDefaults*,SEL,NSString*);
NSArray* fakeArray(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realArray(self,sel,key);
}
NSDictionary* (*realDictionary)(NSUserDefaults*,SEL,NSString*);
NSDictionary* fakeDictionary(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realDictionary(self,sel,key);
}
NSString* (*realString)(NSUserDefaults*,SEL,NSString*);
NSString* fakeString(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realString(self,sel,key);
}
NSArray* (*realStringArray)(NSUserDefaults*,SEL,NSString*);
NSArray* fakeStringArray(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realStringArray(self,sel,key);
}
NSData* (*realData)(NSUserDefaults*,SEL,NSString*);
NSData* fakeData(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realData(self,sel,key);
}
BOOL (*realBool)(NSUserDefaults*,SEL,NSString*);
BOOL fakeBool(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realBool(self,sel,key);
}
NSInteger (*realInteger)(NSUserDefaults*,SEL,NSString*);
NSInteger fakeInteger(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realInteger(self,sel,key);
}
float (*realFloat)(NSUserDefaults*,SEL,NSString*);
float fakeFloat(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realFloat(self,sel,key);
}
double (*realDouble)(NSUserDefaults*,SEL,NSString*);
double fakeDouble(NSUserDefaults* self,SEL sel,NSString* key)
{
	takeKey(key);
	return realDouble(self,sel,key);
}

__attribute__((constructor)) void l()
{
	swizzleImp(@"NSUserDefaults",@"valueForKey:",true,fakeValue,&realValue);
	swizzleImp(@"NSUserDefaults",@"objectForKey:",true,fakeObject,&realObject);
	swizzleImp(@"NSUserDefaults",@"URLForKey:",true,fakeURL,&realURL);
	swizzleImp(@"NSUserDefaults",@"arrayForKey:",true,fakeArray,&realArray);
	swizzleImp(@"NSUserDefaults",@"dictionaryForKey:",true,fakeDictionary,&realDictionary);
	swizzleImp(@"NSUserDefaults",@"stringForKey:",true,fakeString,&realString);
	swizzleImp(@"NSUserDefaults",@"stringArrayForKey:",true,fakeStringArray,&realStringArray);
	swizzleImp(@"NSUserDefaults",@"dataForKey:",true,fakeData,&realData);
	swizzleImp(@"NSUserDefaults",@"boolForKey:",true,fakeBool,&realBool);
	swizzleImp(@"NSUserDefaults",@"integerForKey:",true,fakeInteger,&realInteger);
	swizzleImp(@"NSUserDefaults",@"floatForKey:",true,fakeFloat,&realFloat);
	swizzleImp(@"NSUserDefaults",@"doubleForKey:",true,fakeDouble,&realDouble);
}

CFPropertyListRef fakeCFPreferencesCopyAppValue(CFStringRef key,CFStringRef application)
{
	takeKey(key);
	return CFPreferencesCopyAppValue(key,application);
}
DYLD_INTERPOSE(fakeCFPreferencesCopyAppValue,CFPreferencesCopyAppValue)

CFDictionaryRef fakeCFPreferencesCopyMultiple(CFArrayRef keys,CFStringRef application,CFStringRef user,CFStringRef host)
{
	for(NSString* key in (NSArray*)keys)
	{
		takeKey(key);
	}
	return CFPreferencesCopyMultiple(keys,application,user,host);
}
DYLD_INTERPOSE(fakeCFPreferencesCopyMultiple,CFPreferencesCopyMultiple)

CFPropertyListRef fakeCFPreferencesCopyValue(CFStringRef key,CFStringRef application,CFStringRef user,CFStringRef host)
{
	takeKey(key);
	return CFPreferencesCopyValue(key,application,user,host);
}
DYLD_INTERPOSE(fakeCFPreferencesCopyValue,CFPreferencesCopyValue)

Boolean fakeCFPreferencesGetAppBooleanValue(CFStringRef key,CFStringRef application,Boolean* keyExistsAndHasValidFormat)
{
	takeKey(key);
	return CFPreferencesGetAppBooleanValue(key,application,keyExistsAndHasValidFormat);
}
DYLD_INTERPOSE(fakeCFPreferencesGetAppBooleanValue,CFPreferencesGetAppBooleanValue)

CFIndex fakeCFPreferencesGetAppIntegerValue(CFStringRef key,CFStringRef application,Boolean* keyExistsAndHasValidFormat)
{
	takeKey(key);
	return CFPreferencesGetAppIntegerValue(key,application,keyExistsAndHasValidFormat);
}
DYLD_INTERPOSE(fakeCFPreferencesGetAppIntegerValue,CFPreferencesGetAppIntegerValue)