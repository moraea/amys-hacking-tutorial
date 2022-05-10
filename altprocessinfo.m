// alternatives to NSProcessInfo

// clang -fmodules altprocessinfo.m -o /tmp/a && /tmp/a

@import Foundation;
@import MachO.dyld;
#import <libproc.h>

#define trace NSLog

int main()
{
	NSString* process0=NSProcessInfo.processInfo.arguments[0];
	trace(@"0 %@",process0);
	
	// seems to get the enclosing folder, not the executable itself
	// still fine for checking Safari.app though
	NSString* process1=NSBundle.mainBundle.bundlePath;
	trace(@"1 %@",process1);
	
	char process2buffer[1000];
	unsigned int process2size=1000;
	_NSGetExecutablePath(process2buffer,&process2size);
	NSString* process2=[NSString stringWithUTF8String:process2buffer];
	trace(@"2 %@",process2);
	
	// i am not sure what the working directory for apps is, this is probably useless though
	char* process3buffer=getwd(NULL);
	NSString* process3=[NSString stringWithUTF8String:process3buffer];
	free(process3buffer);
	trace(@"3 %@",process3);
	
	// MAGIC FROM FLAGERS
	char process4buffer[PROC_PIDPATHINFO_MAXSIZE];
	proc_pidpath(getpid(),process4buffer,PROC_PIDPATHINFO_MAXSIZE);
	NSString* process4=[NSString stringWithUTF8String:process4buffer];
	trace(@"4 %@",process4);
}