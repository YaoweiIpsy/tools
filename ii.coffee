request = require "request"

object =
  access_token: "MTQ0NjI4OTo0NDk2NTgzMzY4Nzk1OTY4Mzo5MjIzMzcyMDM2ODU0Nzc1ODA3fDE0ODk0NDc2NjI6MC0tNzg1MjYxODY1NGY1MmUwZDBhMDdmYzk3ZWI4ODU3YmQ=",
  start_date: "2018-06-02",
  end_date: "2018-06-11",
  data_source: "REALTIME",
  granularity: "HOUR"

request.get {url:"https://api.pinterest.com/ads/v0/ad_groups/2680060588443/delivery_metrics/", qs: object }, (err,response,body) ->
  if ( err )
    console.log err
    return
  console.log(body)
