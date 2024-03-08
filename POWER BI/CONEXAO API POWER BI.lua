let  
   body = "POST",
   Data= Web.Contents("http://ap3.stc.srv.br/integration/prod/ws/getClientVehicles?key=b05d64cdd21ae22bf11527547f6a48ef&user=apimedicar&pass=95b707df17b0227ce1c0241301891601",[Content=Text.ToBinary(body),Headers=[#"Content-Type"="application/json"]]),
   DataRecord = Json.Document(Data),
   Source=DataRecord,
    data = Source[data],
    #"Convertido para Tabela" = Table.FromList(data, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 Expandido" = Table.ExpandRecordColumn(#"Convertido para Tabela", "Column1", {"vehicleId", "plate", "label", "positionId", "date", "dateUTC", "realtime", "systemDate", "ignition", "speed", "output1", "output2", "latitude", "longitude", "address", "deviceModel", "deviceId", "mainBattery", "backupBattery", "driverId", "driverName", "vehicleType", "odometer", "horimeter", "rpm", "temp1", "temp2", "temp3", "direction", "header", "gpsFix", "isLbs", "mcc", "mnc", "cell", "lac", "rxlvl", "ta", "nBrCellId1", "nBrCellId2", "nBrCellId3", "nBrCellId4", "nBrCellId5", "nBrCellId6", "originPosition", "batteryPercentual"}, {"Column1.vehicleId", "Column1.plate", "Column1.label", "Column1.positionId", "Column1.date", "Column1.dateUTC", "Column1.realtime", "Column1.systemDate", "Column1.ignition", "Column1.speed", "Column1.output1", "Column1.output2", "Column1.latitude", "Column1.longitude", "Column1.address", "Column1.deviceModel", "Column1.deviceId", "Column1.mainBattery", "Column1.backupBattery", "Column1.driverId", "Column1.driverName", "Column1.vehicleType", "Column1.odometer", "Column1.horimeter", "Column1.rpm", "Column1.temp1", "Column1.temp2", "Column1.temp3", "Column1.direction", "Column1.header", "Column1.gpsFix", "Column1.isLbs", "Column1.mcc", "Column1.mnc", "Column1.cell", "Column1.lac", "Column1.rxlvl", "Column1.ta", "Column1.nBrCellId1", "Column1.nBrCellId2", "Column1.nBrCellId3", "Column1.nBrCellId4", "Column1.nBrCellId5", "Column1.nBrCellId6", "Column1.originPosition", "Column1.batteryPercentual"}),
    #"Colunas Renomeadas" = Table.RenameColumns(#"Column1 Expandido",{{"Column1.vehicleId", "vehicleId"}, {"Column1.plate", "plate"}, {"Column1.label", "label"}, {"Column1.positionId", "positionId"}, {"Column1.date", "date"}, {"Column1.dateUTC", "dateUTC"}, {"Column1.realtime", "realtime"}, {"Column1.systemDate", "systemDate"}, {"Column1.ignition", "ignition"}, {"Column1.speed", "speed"}, {"Column1.output1", "output1"}, {"Column1.output2", "output2"}, {"Column1.latitude", "latitude"}, {"Column1.longitude", "longitude"}, {"Column1.address", "address"}, {"Column1.deviceModel", "deviceModel"}, {"Column1.deviceId", "deviceId"}, {"Column1.mainBattery", "mainBattery"}, {"Column1.backupBattery", "backupBattery"}, {"Column1.driverId", "driverId"}, {"Column1.driverName", "driverName"}, {"Column1.vehicleType", "vehicleType"}, {"Column1.odometer", "odometer"}, {"Column1.horimeter", "horimeter"}, {"Column1.rpm", "rpm"}, {"Column1.temp1", "temp1"}, {"Column1.temp2", "temp2"}, {"Column1.temp3", "temp3"}, {"Column1.direction", "direction"}, {"Column1.header", "header"}, {"Column1.gpsFix", "gpsFix"}, {"Column1.isLbs", "isLbs"}, {"Column1.mcc", "mcc"}, {"Column1.mnc", "mnc"}, {"Column1.cell", "cell"}, {"Column1.lac", "lac"}, {"Column1.rxlvl", "rxlvl"}, {"Column1.ta", "ta"}, {"Column1.nBrCellId1", "nBrCellId1"}, {"Column1.nBrCellId2", "nBrCellId2"}, {"Column1.nBrCellId3", "nBrCellId3"}, {"Column1.nBrCellId4", "nBrCellId4"}, {"Column1.nBrCellId5", "nBrCellId5"}, {"Column1.nBrCellId6", "nBrCellId6"}, {"Column1.originPosition", "originPosition"}, {"Column1.batteryPercentual", "batteryPercentual"}}),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Colunas Renomeadas",{{"date", type datetime}, {"dateUTC", type datetime}, {"systemDate", type datetime}, {"speed", Int64.Type}})
in
    #"Tipo Alterado"




let  
   -- METODO POST
   body = "POST",
   -- LINK DA API
   Data = Web.Contents("http://ap3.stc.srv.br/integration/prod/ws/getClientVehicles?key=b05d64cdd21ae22bf11527547f6a48ef&user=medicar&pass=b070397d856d601a1571857128aca62b",[Content=Text.ToBinary(body),Headers=[#"Content-Type"="application/json"]]),
   -- CONVERTE PARA JSON
   DataRecord = Json.Document(Data),
   -- PEGA OS DADOS
   Source = DataRecord,
   dados = Source[dados],
   -- TRNASFORMA EM TABELA
   #"Convertido para Tabela" = Table.FromList(dados, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
in
    #"Convertido para Tabela"