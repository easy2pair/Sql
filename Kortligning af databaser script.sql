--Brug denne kode til at kortligge data i en database. Query DB skal vælges inden koden køres
SELECT
 sc.name schemaName
 , t.name TableName
 , col.name ColumnName
 , ty.name TypeName
 , col.max_length 
 , col.scale, col.precision
 ,t.type_desc
 , rowcnt.[RowCount]
FROM sys.objects t INNER JOIN sys.schemas sc ON sc.schema_id=t.schema_id
INNER JOIN sys.all_columns col ON col.object_id=t.object_id
INNER JOIN sys.types ty ON ty.user_type_id=col.user_type_id
LEFT JOIN (SELECT
      SCHEMA_NAME(sOBJ.schema_id) SCHEMA_NAME, sOBJ.name AS ObjectName
      , SUM(sPTN.Rows) AS [RowCount]
FROM 
      sys.objects AS sOBJ
      INNER JOIN sys.partitions AS sPTN ON sOBJ.object_id = sPTN.object_id
WHERE sOBJ.type = 'U' AND sOBJ.is_ms_shipped = 0x0 AND index_id < 2 -- 0:Heap, 1:Clustered
GROUP BY sOBJ.schema_id, sOBJ.name
) rowcnt
ON rowcnt.schema_name=sc.name AND rowcnt.ObjectName = t.name