exec = require('child_process').execSync

String.prototype.format = ->
  args = arguments
  return this.replace /{(\d+)}/g, (match, number) ->
    return if typeof args[number] isnt 'undefined' then args[number] else match


createTable = (tablename) ->
  console.log "------------------ Create #{tablename} ------------------"
  createTableSchema = '''
  jaws dynamodb create-table \\
  --table-name {0} \\
  --attribute-definitions {1} \\
  --key-schema {2} \\
  --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \\
  --region local --endpoint-url http://localhost:8000
  '''
  desc_table = JSON.parse(exec("jaws dynamodb describe-table --table-name #{tablename}").toString())
  try
    exec("jaws dynamodb delete-table --table-name #{tablename} --region local --endpoint-url http://localhost:8000 2>/dev/null")
  catch error
    console.log "---"
  exec(createTableSchema.format tablename,
    ("AttributeName=#{it.AttributeName},AttributeType=#{it.AttributeType}" for it in desc_table.Table.AttributeDefinitions).join(" "),
    ("AttributeName=#{it.AttributeName},KeyType=#{it.KeyType}" for it in desc_table.Table.KeySchema).join(" ")
  )
  console.log "-+---------------- #{tablename} done---------------+--"

dumpData = (tablename) ->
  putItemSchema = '''
aws dynamodb put-item \\
--table-name {0} \\
--item '{1}' \\
--return-consumed-capacity TOTAL \\
--region local \\
--endpoint-url http://localhost:8000

'''
  datas = JSON.parse(exec("jaws dynamodb scan --table-name #{tablename}").toString())
  console.log "------------------ Dump #{tablename} Count: #{datas.Count} ------------------"
  count = 0
  for item in datas.Items
    try
      exec( putItemSchema.format(tablename,JSON.stringify(item)))
    catch error
        console.log "-----#----"
    if count % 100 == 0
      console.log "@ - #{count+1}"
    count += 1
  console.log "-+---------------- #{tablename} done---------------+--"

# create all table
tablesnames = JSON.parse(exec("jaws dynamodb list-tables").toString()).TableNames


#createTable "AdsJobInfo"
#dumpData "AdsJobInfo"
#createTable tablename for tablename in tablesnames

for tablename in tablesnames
  if tablename[0..2] == "Pin"
    dumpData tablename
