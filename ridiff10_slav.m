// clang -fmodules ridiff10_slav.m -o /tmp/i && /tmp/i

@import Foundation;
@import Darwin.POSIX.dlfcn;
#define trace NSLog

int (*soft_RawImagePatch)(void**)=NULL;
void extract(char* input,char* output)
{
	if(!soft_RawImagePatch)
	{
		dlopen("/usr/lib/libParallelCompression.dylib",RTLD_LAZY);
		soft_RawImagePatch=dlsym(RTLD_DEFAULT,"RawImagePatch");
		assert(soft_RawImagePatch);
	}
	
	void* thing[10]={0};
	thing[3]=output;
	thing[4]=input;
	thing[6]=(void*)2;
	
	int result=soft_RawImagePatch(thing);
	trace(@"result %d",result);
	assert(result==0);
}

int main()
{
	unlink("amycryptex.dmg");
	extract("cryptex-app 13.1 dp1 ia","amycryptex.dmg");
	extract("cryptex-app rsr","amycryptex.dmg");
	
	// revert
	extract("cryptex-app-rev rsr","amycryptex.dmg");
}