// clang -fmodules -I ../non-metal-common/Utils -dynamiclib safaridelay2.m -o /tmp/VenturaSafariRaceHack.dylib && codesign -fs - /tmp/VenturaSafariRaceHack.dylib && echo '/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app/Contents/MacOS/Safari' > /tmp/VenturaSafariRaceHack.txt
// log stream -predicate 'message contains "Amy.VenturaSafariRaceHack"'

#import "Utils.h"

#define DELAY 0.1

void (*r)(NSObject*,SEL,void*);
void f(NSObject* self,SEL sel,void* rdx)
{
	trace(@"viewDidAdvanceToRunPhase enter %@ %@",self,rdx);
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,DELAY*NSEC_PER_SEC),dispatch_get_current_queue(),^()
	{
		trace(@"viewDidAdvanceToRunPhase complete %@ %@",self,rdx);
		
		r(self,sel,rdx);
	});
}

__attribute__((constructor)) void l()
{
	tracePrefix=@"Amy.VenturaSafariRaceHack";
	traceLog=true;
	
	trace(@"activate");
	
	swizzleImp(@"NSRemoteViewControllerAuxiliary",@"viewDidAdvanceToRunPhase:",true,f,&r);
}