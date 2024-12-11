
cd "C:\Program Files\Oracle\VirtualBox"

.\VBoxManage.exe modifyvm "Mac" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff

 .\VBoxManage.exe setextradata "Mac" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac19,3"

 .\VBoxManage.exe setextradata "Mac" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"

 .\VBoxManage.exe setextradata "Mac" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"

 .\VBoxManage.exe setextradata "Mac" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"

 .\VBoxManage.exe setextradata "Mac" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 0

 .\VBoxManage setextradata "Mac" "VBoxInternal/TM/TSCMode" "RealTSCOffset"