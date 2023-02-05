// clang -fmodules -dynamiclib metaliskil.m -o /tmp/m && codesign -fs - /tmp/m && DYLD_INSERT_LIBRARIES=/tmp/m /S*/A*/Maps.app/C*/M*/Maps

@import Metal;
@import CoreGraphics;
#import "dyld-interposing.h"
#define trace NSLog

id fake_MTLCreateSystemDefaultDevice()
{
	trace(@"Amy stub MTLCreateSystemDefaultDevice %@",NSThread.callStackSymbols);
	return nil;
}
DYLD_INTERPOSE(fake_MTLCreateSystemDefaultDevice,MTLCreateSystemDefaultDevice)

NSArray* fake_MTLCopyAllDevices()
{
	trace(@"Amy stub MTLCopyAllDevices %@",NSThread.callStackSymbols);
	return NSArray.alloc.init;
}
DYLD_INTERPOSE(fake_MTLCopyAllDevices,MTLCopyAllDevices)

NSArray* fake_MTLCopyAllDevicesWithObserver(id observer,MTLDeviceNotificationHandler handler)
{
	trace(@"Amy stub MTLCopyAllDevicesWithObserver %@",NSThread.callStackSymbols);
	return NSArray.alloc.init;
}
DYLD_INTERPOSE(fake_MTLCopyAllDevicesWithObserver,MTLCopyAllDevicesWithObserver)

id fake_CGDirectDisplayCopyCurrentMetalDevice(CGDirectDisplayID display)
{
	trace(@"Amy stub CGDirectDisplayCopyCurrentMetalDevice %@",NSThread.callStackSymbols);
	return nil;
}
DYLD_INTERPOSE(fake_CGDirectDisplayCopyCurrentMetalDevice,CGDirectDisplayCopyCurrentMetalDevice)