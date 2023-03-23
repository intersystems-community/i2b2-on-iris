Class I2B2onFHIR.Main Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="I2B2onFHIR.Main" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Test" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
    <Setting Target="Adapter" Name="FilePath">/irisrun/repo/data_files/</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Processes.Main</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/irisrun/repo/data_files/Archive/</Setting>
  </Item>
  <Item Name="Processes.Main" Category="" ClassName="I2B2onFHIR.Processes.Main" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Services.GetFHIRFIle" Category="" ClassName="I2B2onFHIR.Services.GetFHIRFIle" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
    <Setting Target="Adapter" Name="FilePath">/irisrun/repo/data_files/</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/irisrun/repo/data_files/Archive/</Setting>
    <Setting Target="Adapter" Name="ConfirmComplete">1</Setting>
    <Setting Target="Host" Name="ErrorFoldierPath">/irisrun/repo/data_files/Errors/</Setting>
    <Setting Target="Host" Name="MoveFileToErrorFoldier">1</Setting>
  </Item>
  <Item Name="Operations.SaveDataToI2B2" Category="" ClassName="I2B2onFHIR.Operations.SaveDataToI2B2" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
    <Setting Target="Adapter" Name="DSN">Userunixodbc</Setting>
    <Setting Target="Adapter" Name="Credentials"></Setting>
  </Item>
  <Item Name="Processes.Patient" Category="" ClassName="I2B2onFHIR.Processes.Patient" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Processes.Encounter" Category="" ClassName="I2B2onFHIR.Processes.Encounter" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Processes.Practitioner" Category="" ClassName="I2B2onFHIR.Processes.Practitioner" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Operations.CheckDataInI2B2" Category="" ClassName="I2B2onFHIR.Operations.CheckDataInI2B2" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="Processes.ObservationFact" Category="" ClassName="I2B2onFHIR.Processes.ObservationFact" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="I2B2onFHIR.Processes.ExportFhir2File" Category="" ClassName="I2B2onFHIR.Processes.ExportFhir2File" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="I2B2onFHIR.Operations.SaveFHIR" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/irisrun/repo</Setting>
    <Setting Target="Host" Name="Filename">%f_%Q%!+(_a).json</Setting>
  </Item>
  <Item Name="I2B2onFHIR.Operations.GetFHIR" Category="" ClassName="EnsLib.HTTP.GenericOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">localhost</Setting>
  </Item>
</Production>
}

}

