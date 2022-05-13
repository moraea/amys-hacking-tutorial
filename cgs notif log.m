// clang -fmodules -I ../*/non-metal-frameworks/SkyLight -I ../*/non-metal-common/Utils -dynamiclib 'cgs notif log.m' -o /tmp/c -F /S*/L*/PrivateFrameworks -framework SkyLight && codesign -f -s - /tmp/c && launchctl setenv DYLD_INSERT_LIBRARIES /tmp/c && log stream --predicate 'message contains "fake_SLSRegisterConnectionNotifyProc"'

@import AppKit;
#import "Utils.h"
#import "Extern.h"

unsigned int fake_SLSRegisterConnectionNotifyProc(unsigned int edi_connectionID,void (*rdi_callback)(),unsigned int edx_type,char* rcx_context)
{
	traceLog=true;
	tracePrint=false;
	
	trace(@"fake_SLSRegisterConnectionNotifyProc %d %p 0x%x %p",edi_connectionID,rdi_callback,edx_type,rcx_context);
	
	return SLSRegisterConnectionNotifyProc(edi_connectionID,rdi_callback,edx_type,rcx_context);
}

DYLD_INTERPOSE(fake_SLSRegisterConnectionNotifyProc,SLSRegisterConnectionNotifyProc)