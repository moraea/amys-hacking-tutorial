// clang -fmodules -dynamiclib -Wno-unused-getter-return-value -I ../git/non-metal-common/Utils '802 swizzle 3.m' -o /tmp/8.dylib && scp /tmp/8.dylib cass14.local:/tmp

// codesign -fs - /tmp/8.dylib && launchctl setenv DYLD_INSERT_LIBRARIES /tmp/8.dylib && killall -9 airportd && log stream -predicate 'process contains "airportd" or sender contains "IO80211"' -debug -info

#import "Utils.h"
@import Darwin;

BOOL enable=false;

char* (*soft_convertApple80211IOCTLToString)(int)=NULL;

__attribute__((constructor)) void l()
{
	if(![NSProcessInfo.processInfo.arguments[0] containsString:@"airportd"])
	{
		return;
	}
	
	// so log command can start lol
	
	[NSThread sleepForTimeInterval:1];
	
	traceLog=true;
	tracePrefix=@"amy 802";
	
	soft_convertApple80211IOCTLToString=dlsym(RTLD_DEFAULT,"convertApple80211IOCTLToString");
	assert(soft_convertApple80211IOCTLToString);
	
	for(int i=0;;i++)
	{
		char* string=soft_convertApple80211IOCTLToString(i);
		trace(@"ioctl %d %s",i,string);
		if(!strcmp(string,"Error Invalid ioctl"))
		{
			break;
		}
	}
	
	enable=true;
}

int fake_ioctl(int file,long op,...)
{
	// assumes only 1 arg, seems safe for airportd but not universally
	
	char* arg;
	va_list args;
	va_start(args,op);
	arg=va_arg(args,char*);
	va_end(args);
	
	BOOL usesStruct=false;
	
	switch(op)
	{
		// Apple80211BindToInterfaceWithIOCTL
		// Apple80211IOCTLGetWrapper
		// Apple80211IOCTLSetWrapper
		
		case 0xc0206911:
		case 0xc02869c9:
		case 0x802869c8:
			usesStruct=true;
	}
	
	if(!enable||!usesStruct)
	{
		return ioctl(file,op,arg);
	}
	
	long* selector=(long*)(arg+0x10);
	long* size=(long*)(arg+0x18);
	
	trace(@"ioctl fd %d ioctl opcode %lx struct opcode %ld (%s) struct size %ld stack %@",file,op,*selector,soft_convertApple80211IOCTLToString(*selector),*size,NSThread.callStackSymbols);
	
	if(*selector==11)
	{
		trace(@"dp1 hack APPLE80211_IOC_SCAN_RESULT size");
		
		*size=1164;
	}
	
	int status=ioctl(file,op,arg);
	
	if(*selector==10)
	{
		trace(@"dp3 hack APPLE80211_IOC_SCAN_REQ delay");
		
		[NSThread sleepForTimeInterval:3];
	}
	
	return status;
}

DYLD_INTERPOSE(fake_ioctl,ioctl)