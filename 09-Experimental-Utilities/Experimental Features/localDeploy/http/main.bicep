extension http

param vehicle {
  licensePlate: string
}

@description('HTTP Request')
resource vehicleInfoReq 'HttpRequest' = {
  uri: '/${vehicle.licensePlate}'
  format: 'raw'
}

@description('Collecting raw response')
var rawResponse = json(vehicleInfoReq.body)[0]

@description('Time to display some car statics')
output carBrand string = 'Your car brand is: ${rawResponse.merk}' 
output carColor string = 'Your car color is: ${rawResponse.eersteKleur}'
