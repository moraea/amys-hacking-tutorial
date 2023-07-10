set -e

cd ~/Desktop

rm -rf IO80211FamilyLegacy.kext
cp -R '/Volumes/Temporary 39/Unfiled/versions.noindex/13.5 (22G5038d)/kdk/System/Library/Extensions/IO80211FamilyLegacy.kext' .

PATH+=:/Volumes/Files/sonoma/tmp/spaghetti

Binpatcher IO80211FamilyLegacy.kext/Contents/MacOS/IO80211FamilyLegacy IO80211FamilyLegacy.kext/Contents/MacOS/IO80211FamilyLegacy '

# getScanResult ignore struct size mismatch

set 0x78a83
nop 0x6

# setScanRequest skip if pending

# mov rdi,r14
# call __ZN17IO80211Controller30getPrimaryInterfaceScanManagerEv
# mov rax,qword[rax+0x10]
# test rax,rax
# je 0x84077
# xor ebx,ebx
# jmp 0x840ae

set 0x84048
write 0x4c89f7e87afd0000488b40104885c0741e31dbeb51

'