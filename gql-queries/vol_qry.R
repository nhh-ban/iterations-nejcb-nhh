# Function that creates the API query with custom parameters for id and datetime range
vol_qry <- function(id, from, to) {
  qry <- paste0('
{
  trafficData(trafficRegistrationPointId: "',id,'") {
    volume {
      byHour(from: "',from,'", to: "',to,'") {
        edges {
          node {
            from
            to
            total {
              volumeNumbers {
                volume
              }
            }
          }
        }
      }
    }
  }
}')
  return(qry)
}