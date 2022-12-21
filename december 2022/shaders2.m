// dump all GL shaders compiled by WindowServer
// quite difficult since GLEngine uses a function pointer system that prevents interposing
// so, possibly sets a new personal record for cursed-ness...

// clang -fmodules -dynamiclib shaders2.m -o /tmp/amyshaders.dylib && codesign -fs - /tmp/amyshaders.dylib && sudo launchctl setenv DYLD_INSERT_LIBRARIES /tmp/amyshaders.dylib && sudo killall -9 WindowServer

@import Foundation;
@import Darwin;

int file;

void (*real)(void*,void*,int,char**,int*);

void mine(void* rdi,void* shader,int count,char** strings,int* lengths)
{
	NSString* message=[NSString stringWithFormat:@"%d --- %s --- %@\n\n",count,strings[0],NSThread.callStackSymbols];
	write(file,message.UTF8String,message.length);
	
	real(rdi,shader,count,strings,lengths);
}

char* fuck(char* victim,char* fake)
{
	char* base=victim-(long)victim%0x1000;
	assert(mprotect(base,0x2000,PROT_READ|PROT_WRITE|PROT_EXEC)==0);
	
	// TODO: blindly moves 12 bytes at the start of the victim function
	// unlikely to work for arbitrary other functions
	
	char* backup=malloc(0x2000);
	backup+=0x1000-(long)backup%0x1000;
	assert(mprotect(backup,0x1000,PROT_READ|PROT_WRITE|PROT_EXEC)==0);
	memcpy(backup,victim,12);
	char* back=victim+12;
	memcpy(backup+12,"\x48\xB8",2);
	memcpy(backup+14,&back,8);
	memcpy(backup+22,"\xff\xe0",2);
	
	memcpy(victim,"\x48\xB8",2);
	memcpy(victim+2,&fake,8);
	memcpy(victim+10,"\xff\xe0",2);
	
	return backup;
}

__attribute__((constructor)) void load()
{
	if([NSProcessInfo.processInfo.arguments[0] containsString:@"WindowServer"])
	{
		NSString* name=[NSString stringWithFormat:@"/tmp/amy.shaders.%d.log",getpid()];
		file=open(name.UTF8String,O_RDWR|O_CREAT|O_TRUNC);
		assert(file>0);
		
		// TODO: needless to say, this will only work on the particular OpenGL used in non-Metal
		// since the function is private and hardcoded offsets were used
		
		char* library=dlopen("/System/Library/Frameworks/OpenGL.framework/Versions/A/Resources/GLEngine.bundle/GLEngine",RTLD_NOW);
		char* reference=dlsym(library,"gleFinishCommandBuffer");
		assert(reference);
		char* victim=(reference-0xfb5ae)+0x78386;
		
		real=fuck(victim,mine);
	}
}