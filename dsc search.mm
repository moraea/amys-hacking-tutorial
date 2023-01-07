// clang++ -fmodules -fcxx-modules -std=c++17 -Wno-unused-getter-return-value -I '/Volumes/Files/Ventura/dsc/old/x - hub' -I /Volumes/Files/Ventura/dsc search.mm -o /tmp/search && /tmp/search /System/Volumes/Preboot/Cryptexes/OS/System/Library/dyld/dyld_shared_cache_x86_64 'Current system appearance'

#import "Extern.h"
#define trace NSLog
#import "LocationBase.h"
#import "Location.h"
@class Image;
#import "CacheFile.h"
#import "ImageHeader.h"
#import "Symbol.h"
#import "Image.h"
#import "Cache.h"

#import "Location.m"
#import "CacheFile.m"
#import "ImageHeader.m"
#import "Symbol.m"
#import "Image.m"
#import "Cache.m"

int main(int argc,char** argv)
{
	if(argc!=3)
	{
		trace(@"usage: %s <first cache> 'error message'",argv[0]);
		return 1;
	}
	
	NSString* cachePath=[NSString stringWithUTF8String:argv[1]];
	Cache* cache=[Cache.alloc initWithPathPrefix:cachePath].autorelease;
	assert(cache);
	
	NSData* target=[NSData dataWithBytes:argv[2] length:strlen(argv[2])];
	assert(target);
	
	BOOL success=false;
	for(CacheFile* file in cache.files)
	{
		NSRange range=[file.data rangeOfData:target options:0 range:NSMakeRange(0,file.data.length)];
		if(range.location!=NSNotFound)
		{
			Image* image=[cache imageWithAddress:wrapOffset(file,range.location).address];
			trace(@"\e[36mfound %@\e[0m",image.path);
			success=true;
		}
	}
	
	return success?0:1;
}