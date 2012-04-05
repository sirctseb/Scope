REM "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64
mkdir "C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\build\Core\ClientSMLSWIG\CSharp\src\sml"
%SWIG_HOME%swig ^
 -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\shared" ^
 -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\pcre" ^
  -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\SoarKernel\src" ^
   -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\ElementXML\src" ^
   -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\KernelSML\src" ^
   -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\ConnectionSML\src" ^
   -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\ClientSML\src" ^
   -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\CLI\src" ^
   -o "C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface_wrap.cpp" ^
   -namespace sml ^
   -c++ -csharp -Wall -outdir "C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\build\Core\ClientSMLSWIG\CSharp\src\sml" ^
   "C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.i"
cd ..\..\..\build\Core\ClientSMLSWIG\CSharp\src\sml
REM csc /target:library /out:..\..\sml_CSharp.dll /platform:x64 .\*.cs
%SystemRoot%\Microsoft.NET\Framework\v3.5\csc.exe /target:library /out:..\..\sml_CSharp.dll /platform:x64 ./*.cs
cd ..\..
copy ..\..\..\..\Core\ClientSMLSWIG\CSharp\CSharpCallbackByHand.h .\
cd ..\..\..\..
cl /Fobuild\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.obj ^
/c build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface_wrap.cpp ^
/TP /nologo /EHsc /D _CRT_SECURE_NO_DEPRECATE /D _WIN32 /O2 /W2 ^
/ICore\shared /ICore\pcre /ICore\SoarKernel\src /ICore\ElementXML\src /ICore\KernelSML\src /ICore\ConnectionSML\src ^
/ICore\ClientSML\src /ICore\CLI\src

link /dll /out:build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.dll ^
/implib:build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.lib ^
/LIBPATH:out Soar.lib build\Core\ClientSMLSWIG\CSharp\CSharp_sml_ClientInterface.obj

cd Core\ClientSMLSWIG\CSharp