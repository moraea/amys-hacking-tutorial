// clang -fmodules -dynamiclib -I /Volumes/Files/Ventura/git/non-metal-common/Utils qlp.m -o '/Library/Application Support/SkyLightPlugins/qlp.dylib' && codesign -fs - '/Library/Application Support/SkyLightPlugins/qlp.dylib' && echo '/System/Library/CoreServices/Finder.app/Contents/MacOS/Finder' >  '/Library/Application Support/SkyLightPlugins/qlp.txt'

#import "Utils.h"

void (*r_lwdbi)(NSObject*,SEL,NSString*,NSDictionary*,BOOL);
void f_lwdbi(NSObject* self,SEL sel,NSString* bundle,NSDictionary* hints,BOOL remote)
{
	// fix intermittent failures (no idea why)
	// apparently EduCovas doesn't have this problem at all... it annoys me though
	remote=true;
	
	// massively improve performance browsing through images
	// (at the cost of lower image quality)
	NSMutableDictionary* hints2=hints.mutableCopy;
	hints2[@"noProgressiveLoad"]=@false;
	
	r_lwdbi(self,sel,bundle,hints2,remote);
	
	hints2.release;
}

__attribute__((constructor)) void l()
{
	swizzleImp(@"QLPreviewDocument",@"_loadWithDisplayBundleID:hints:remoteMode:",true,f_lwdbi,&r_lwdbi);
}