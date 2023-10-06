
//Below is an example with ParseCidr
output v4info object = parseCidr('172.16.0.0/16')
// {
//   network: '172.16.0.0'
//   netmask: '255.255.0.0'
//   broadcast: '172.16.255.255'
//   firstUsable: '172.16.0.1'
//   lastUsable: '172.16.255.254'
//   cidr: 16
// }

//Below is an example with CidrSubnet
output v4subnets array = [for i in range(0, 2): cidrSubnet('10.0.0.0/23', 24, i)]
// {
//  "10.0.0.0/24",
//  "10.0.1.0/24"
//  }
