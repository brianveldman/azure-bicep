param __location__ string
param _azTags_ object

resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: 'name'
  location: __location__
  tags: _azTags_
  kind: 'app'
  properties: {
    serverFarmId: 'webServerFarms.id'
    httpsOnly: false
  }
}
