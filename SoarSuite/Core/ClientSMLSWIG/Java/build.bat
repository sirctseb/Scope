// Java SWIG sml process

// create directory for code that will be used client-side
mkdir "C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\build\Core\ClientSMLSWIG\sirc\Java\src\sml"

use swig to create code
%SWIG_HOME%swig ^
 -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\shared"^
 -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\pcre"^
  -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\SoarKernel\src"^
   -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\ElementXML\src"^
   -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\KernelSML\src" ^
   -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\ConnectionSML\src" -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\ClientSML\src" ^
   -I"C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\CLI\src" ^
   -I"C:\Program Files\Java\jdk1.7.0_03\include" ^
   -I"C:\Program Files\Java\jdk1.7.0_03\include\win32" ^
   -o "C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\build\Core\ClientSMLSWIG\sirc\Java\Java_sml_ClientInterface_wrap.cpp" ^
   -namespace sml ^
   -c++ -java -Wall -package sml -outdir "C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\build\Core\ClientSMLSWIG\sirc\Java\src\sml" ^
   "C:\Users\cjbest\Desktop\Coping\Soar9.3.2\SoarSuite\Core\ClientSMLSWIG\Java\Java_sml_ClientInterface.i"




// i don't know
// this must compile build/Core/ClientSMLSWIG/Java/src to build/Core/ClientSMLSWIG/Java/classes
REM javac @c:\users\cjbest\appdata\local\temp\tmpehutkt.lnk


// create a jar of compiled java - i think this is what the client code refers to
REM jar cf build\Core\ClientSMLSWIG\Java\sml.jar -C build\Core\ClientSMLSWIG\Java\classes .

// copy hand coded stuff to build dir
REM Copy("build\Core\ClientSMLSWIG\Java\JavaCallbackByHand.h", "Core\ClientSMLSWIG\Java\JavaCallbackByHand.h")
// compile swig code
REM cl /Fobuild\Core\ClientSMLSWIG\Java\Java_sml_ClientInterface_wrap.obj
 REM /c build\Core\ClientSMLSWIG\Java\Java_sml_ClientInterface_wrap.cpp
  REM /TP /nologo /EHsc /D _CRT_SECURE_NO_DEPRECATE /D _WIN32 /O2 /W2
   REM /ICore\shared /ICore\pcre /ICore\SoarKernel\src /ICore\ElementXML\src /ICore\KernelSML\src /ICore\ConnectionSML\src
   REM /ICore\ClientSML\src /ICore\CLI\src "/IC:\Program Files\Java\jdk1.7.0_03\include" "/IC:\Program Files\Java\jdk1.7.0_03\include\win32"

REM Warning: Only used interfaces imported from Soar.dll

// link with soar
REM link /dll /out:build\Core\ClientSMLSWIG\Java\Java_sml_ClientInterface.dll
REM /implib:build\Core\ClientSMLSWIG\Java\Java_sml_ClientInterface.lib
REM /LIBPATH:out "/LIBPATH:C:\Program Files\Java\jdk1.7.0_03\lib" Soar.lib advapi32.lib build\Core\ClientSMLSWIG\Java\Java_sml_ClientInterface_wrap.obj