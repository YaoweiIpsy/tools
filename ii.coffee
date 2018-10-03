request = require "request"

object =
	access_token: "MTQ0NjI4OTo0NDk2NTgzMzY4Nzk1OTY4Mzo5MjIzMzcyMDM2ODU0Nzc1ODA3fDE0ODk0NDc2NjI6MC0tNzg1MjYxODY1NGY1MmUwZDBhMDdmYzk3ZWI4ODU3YmQ=",
	start_date: "2018-07-01",
	end_date: "2018-10-02",
	data_source: "OFFLINE",

fetch = (adGroupId) ->
#		granularity: "HOUR"
	return new Promise (resolve,reject) ->
		request.get {url:"https://api.pinterest.com/ads/v0/ad_groups/#{adGroupId}/delivery_metrics/", qs: object }, (err,response,body) ->
			if ( err )
#				console.log err
				reject err
			else
				resolve JSON.parse(body)


fs = require "fs"

main = () ->
	tt = false

	vv = JSON.parse(fs.readFileSync("111.txt"))
	if tt
		console.log "AdGroup ID,Name,Campaign ID,Records(since #{object.start_date})"
	for item in vv.Items
		if tt
#			console.log item
			aa = await fetch(item.adGroupId.S)
#			console.log aa
			if aa.status == 'failure'
				console.log "#{item.adGroupId.S},#{item.name.S},#{item.campaignId.S},#{aa.error.message}"
			else
				console.log "#{item.adGroupId.S},#{item.name.S},#{item.campaignId.S},#{aa.data.length}"
		else
			tt = (item.adGroupId.S == "2680060117609")

main()