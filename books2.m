// clang -fmodules -I /V*/F*/V*/g*/non-metal-common/Utils -I /V*/F*/V*/g*/non-metal-frameworks/SkyLight -dynamiclib books2.m -F /S*/L*/PrivateFrameworks -framework SkyLight -o '/Library/Application Support/SkyLightPlugins/BooksHacks.dylib' && codesign -fs - '/Library/Application Support/SkyLightPlugins/BooksHacks.dylib' && echo '/System/Applications/Books.app/Contents/MacOS/Books' > '/Library/Application Support/SkyLightPlugins/BooksHacks.txt'

@import AppKit;
#import "Utils.h"
#import "Extern.h"

NSArray* SLSHWCaptureWindowList(int,int*,int,int);

void fake_start(NSObject* self,SEL sel)
{
	// trace(@"_BCULayerRendererOperation start");
	
	dispatch_async(dispatch_get_main_queue(),^()
	{
		CALayer* layer=[self configureLayer];
		layer.geometryFlipped=1;
		CALayer* container=CALayer.alloc.init;
		[container addSublayer:layer];
		
		NSWindow* window=[NSWindow.alloc initWithContentRect:layer.bounds styleMask:0 backing:NSBackingStoreBuffered defer:false];
		window.contentView.wantsLayer=true;
		window.contentView.layer=container;
		container.release;
		window.opaque=false;
		window.backgroundColor=NSColor.clearColor;
	
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW,0.1*NSEC_PER_SEC),dispatch_get_main_queue(),^()
		{
			int wid=[window windowNumber];
			NSArray* images=SLSHWCaptureWindowList(SLSMainConnectionID(),&wid,1,0);
			
			window.release;
			
			if(!images)
			{
				trace(@"failed generating cover");
				return;
			}
			
			NSBitmapImageRep* image=[NSBitmapImageRep.alloc initWithCGImage:images[0]].autorelease;
			trace(@"generated cover %@",image);
			
			[self completeWithImage:image];
		});
	});
}

void (*real_turnPages)(NSObject*,SEL,void*,BOOL);

void fake_turnPages(NSObject* self,SEL sel,void* rdx,BOOL animated)
{
	// trace(@"BKFlowingBookViewController turnPages");
	
	real_turnPages(self,sel,rdx,false);
}

__attribute__((constructor)) void load()
{
	traceLog=true;
	tracePrefix=@"Amy.BooksHack";
	
	swizzleImp(@"_BCULayerRendererOperation",@"start",true,(IMP)fake_start,NULL);
	swizzleImp(@"BKFlowingBookViewController",@"turnPages:animated:",true,(IMP)fake_turnPages,(IMP*)&real_turnPages);
}