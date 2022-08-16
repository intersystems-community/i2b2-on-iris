/// 
/// Author Denis Bulashev
/// Adapter is used to read all files from directory and process them
/// 
Class I2B2onFHIR.Services.GetFHIRFIle Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Parameter DESTINATION = "Processes.Main";

Property MoveFileToErrorFoldier As %Boolean;

Property ErrorFoldierPath As %String;

Parameter SETTINGS = "MoveFileToErrorFoldier:Basic, ErrorFoldierPath:Basic";

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
    s msg = ##class(Ens.StreamContainer).%New(pInput)

	$$$TRACE(pInput.Filename)

    s sc = ..SendRequestSync(..#DESTINATION, msg, .resp)
    i ($$$ISERR(sc)) {
		
		if ..MoveFileToErrorFoldier {
			if ..ErrorFoldierPath '= "" {
				set separator = $s(pInput.Filename["/":"/",1:"\")
				set newFileName = ..ErrorFoldierPath_$p(pInput.Filename,separator,$l(pInput.Filename,separator))
				s sc = ##class(%File).CopyFile(pInput.Filename, newFileName, 0, .return)
				q:$$$ISERR(sc) sc
				s sc = ##class(%File).Delete(pInput.Filename, .return)
				q:$$$ISERR(sc) sc
			}
		}
        q sc
    
    } else {
        $$$LOGINFO("Message was procesed")	
    }
    
 	q $$$OK
}

}
