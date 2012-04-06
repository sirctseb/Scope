copy SoarIMPRINTPlugin\bin\debug\SoarIMPRINTPlugin.dll "C:\Program Files (x86)\IMPRINT Pro 3.0\"
copy Utility\bin\debug\Utility.dll "C:\Program Files (x86)\IMPRINT Pro 3.0\"
xcopy /E /Y ..\TestAgent\* "C:\Program Files (x86)\IMPRINT Pro 3.0\Scope\agent\"
xcopy /E /Y ..\ScopeAgent\* "C:\Program Files (x86)\IMPRINT Pro 3.0\Scope\agent\"