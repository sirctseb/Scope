REM "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64
mkdir "..\..\..\build\Core\ClientSMLSWIG\CSharp\src\sml"
%SWIG_HOME%swig ^
 -I"..\..\shared" ^
 -I"..\..\pcre" ^
  -I"..\..\src" ^
   -I"..\..\ElementXML\src" ^
   -I"..\..\KernelSML\src" ^
   -I"..\..\ConnectionSML\src" ^
   -I"..\..\ClientSML\src" ^
   -I"..\..\CLI\src" ^
   -o "..\..\..\build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface_wrap.cpp" ^
   -namespace sml ^
   -c++ -csharp -Wall -outdir "..\..\..\build\Core\ClientSMLSWIG\CSharp\src\sml" ^
   "CSharp_sml_ClientInterface.i"
cd ..\..\..\build\Core\ClientSMLSWIG\CSharp\src\sml


REM csc /target:library /out:..\..\sml_CSharp.dll /platform:x64 .\*.cs
set csc_exe=%SystemRoot%\Microsoft.NET\Framework\v3.5\csc.exe
%csc_exe% /target:library /out:..\..\sml_CSharp.dll /platform:AnyCPU ./*.cs
cd ..\..

REM set up x86
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86


copy ..\..\..\..\Core\ClientSMLSWIG\CSharp\CSharpCallbackByHand.h .\
cd ..\..\..\..
REM set cl_exe="C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\cl.exe"
REM %cl_exe% /Fobuild\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.obj
cl /Fobuild\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.obj ^
/c build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface_wrap.cpp ^
/TP /nologo /EHsc /D _CRT_SECURE_NO_DEPRECATE /D _WIN32 /O2 /W2 ^
/ICore\shared /ICore\pcre /ICore\SoarKernel\src /ICore\ElementXML\src /ICore\KernelSML\src /ICore\ConnectionSML\src ^
/ICore\ClientSML\src /ICore\CLI\src


REM set link_exe="C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\link.exe"
REM %link_exe% /dll /out:build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.dll
link /dll /out:build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.dll ^
/implib:build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.lib ^
/LIBPATH:out Soar.lib build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.obj

cd Core\ClientSMLSWIG\CSharp