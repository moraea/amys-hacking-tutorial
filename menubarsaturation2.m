// generate binpatcher commands for arbitrary default backdrop saturation (mojave SL)

// clang -fmodules menubarsaturation2.m -o m && ./m
// CREDIT http://www.graficaobscura.com/matrix/index.html !!!

@import Foundation;
#define trace NSLog

// negative = invert, less than 1 = desaturate, 1 = identity, more than 1 = saturate

float s2=1.0;

int main()
{
	int a=0x3fd09b51;
	int b=0xbe2e2972;
	int d=0xbf127913;
	int g=0xbd6c95c0;
	
	float s=*(float*)&a-*(float*)&b;
	
	float rw=*(float*)&b/(1.0-s);
	float gw=*(float*)&d/(1.0-s);
	float bw=*(float*)&g/(1.0-s);
	
	float b2=(1.0-s2)*rw;
	float a2=b2+s2;
	float d2=(1.0-s2)*gw;
	float e2=d2+s2;
	float g2=(1.0-s2)*bw;
	float i2=g2+s2;
	float m[12]={a2,d2,g2,0.0,b2,e2,g2,0.0,b2,d2,i2,0.0};
	printf("# saturation %f\nset 0x26ed60\nwrite 0x",s2);
	for(int i=0;i<12;i++)
	{
		printf("%08x",htonl(((int*)m)[i]));
	}
	printf("\n");
}