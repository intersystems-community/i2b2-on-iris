Class I2B2onFHIR.Processes.Practitioner Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Parameter DESTINATION = "Operations.SaveDataToI2B2";

Method OnRequest(pRequest As Ens.StreamContainer, Output pResponse As Ens.Response) As %Status
{
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
