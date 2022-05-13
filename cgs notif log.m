// clang -fmodules -I ../non-metal-frameworks/SkyLight -I ../non-metal-common/Utils -dynamiclib 'cgs notif log.m' -o /tmp/c -F /S*/L*/PrivateFrameworks -framework SkyLight && codesign -f -s - /tmp/c && launchctl setenv DYLD_INSERT_LIBRARIES /tmp/c && log stream --predicate 'message contains "Moraea: notif"'

@import AppKit;
#import "Utils.h"
#import "Extern.h"

char* (*stringForType)(int);

__attribute__((constructor)) void load()
{
	traceLog=true;
	tracePrint=false;

	long base=SLSMainConnectionID-0x1d8322;
	stringForType=base+0x125639;
}

unsigned int fake_SLSRegisterConnectionNotifyProc(unsigned int edi_connectionID,void (*rsi_callback)(),unsigned int edx_type,char* rcx_context)
{
	trace(@"notif 0x%x %s %@",edx_type,stringForType(edx_type),NSThread.callStackSymbols);
	
	return SLSRegisterConnectionNotifyProc(edi_connectionID,rsi_callback,edx_type,rcx_context);
}

unsigned int fake_SLSRegisterNotifyProc(void (*rdi_callback)(),unsigned int esi_type,char* rdx_context)
{
	trace(@"notif 0x%x %s %@",esi_type,stringForType(esi_type),NSThread.callStackSymbols);
	
	return SLSRegisterNotifyProc(rdi_callback,esi_type,rdx_context);
}

DYLD_INTERPOSE(fake_SLSRegisterConnectionNotifyProc,SLSRegisterConnectionNotifyProc)
DYLD_INTERPOSE(fake_SLSRegisterNotifyProc,SLSRegisterNotifyProc)