#include <portability.h>

#include "sml_Utils.h"
#include "sml_Client.h"
#include "sml_Names.h"
#include "Export.h"

#include <string>
#include <sstream>
#include <iostream>

using namespace sml;
using namespace std;

string myRHSTest(smlRhsEventId id, void* pUserData, Agent* pAgent, char const* pFunctionName, char const* pArgument) {
	return "myRHSTest";
}

#ifdef __cplusplus
extern "C" {
#endif

RHS_EXPORT const char* sml_InitLibrary(Kernel* pKernel, int argc, char** argv) {
	int callbackId = pKernel->AddRhsFunction("test", myRHSTest, 0);
	return "";
}

#ifdef __cplusplus
} // extern "C"
#endif

//
// Stuff to use the library as a standard client (i.e. as an executable)
//

void MyShutdownHandler(smlSystemEventId id, void* pUserData, Kernel* pKernel) {
	pKernel->SetConnectionInfo("RHSemotion", sml_Names::kStatusClosing, sml_Names::kStatusClosing);
	exit(0);
}

int main(int argc, char** argv) {
	sml::Kernel* pKernel = sml::Kernel::CreateRemoteConnection();
	sml_InitLibrary(pKernel, 0, 0);

	assert(pKernel);
	if(pKernel->HadError()) {
		cout << "Error: " << pKernel->GetLastErrorDescription() << endl;
		exit(1);
	}

	// Listen for when to shutdown
	pKernel->RegisterForSystemEvent(smlEVENT_BEFORE_SHUTDOWN, MyShutdownHandler, NULL);

	pKernel->SetConnectionInfo("TestExternalLibraryLib", sml_Names::kStatusReady, sml_Names::kStatusReady);

	cout << endl << "This will automatically close when the remote kernel shuts down." << endl;
	// stay open until the remote Soar is shutdown
	for(;;) { sml::Sleep(100000, 0); }

	pKernel->SetConnectionInfo("RHSemotion", sml_Names::kStatusClosing, sml_Names::kStatusClosing);
    pKernel->Shutdown();
	delete pKernel;

	return 0;
}
