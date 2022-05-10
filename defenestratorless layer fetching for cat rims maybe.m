// fetch window root layer without using Defenestrator.m
// as usual, can't link AppKit

// just use this in place of `wrapperForWindow(windowID).context.layer` in the rim functions

dispatch_once_t layerNewWayOnce;
NSObject* layerNewWayNSApp;
CALayer* layerNewWay(int wid)
{
	dispatch_once(&layerNewWayOnce,^()
	{
		Class NSApplication=NSClassFromString(@"NSApplication");
		layerNewWayNSApp=[NSApplication sharedApplication];
	});
	
	NSObject* window=[layerNewWayNSApp windowWithWindowNumber:wid];
	NSObject* view=[window _borderView];
	
	// this is horrible and i'm not sure why it's necessary
	// since it gets a layer on its own a bit later
	
	if([NSStringFromClass(view.class) isEqual:@"NSNextStepFrame"])
	{
		[view setWantsLayer:true];
	}
	
	CALayer* layer=[view layer];
	while(layer.superlayer)
	{
		layer=layer.superlayer;
	}
	
	trace(@"LNW %@ %@ %@ %@",layerNewWayNSApp,window,view,layer);
	
	return layer;
}