# We can use terraform import

The terraform import was used to obtain the resource already created and import to the terraform state

### CLI

``` bash
terraform import  module.vnet_output.azurerm_subnet.local_virtual_network_subnet subscriptions/e1f178b4-040a-4571-b231-1802c3bab7a0/resourceGroups/virtual-machines-group/providers/Microsoft.Network/virtualNetworks/ci-cd-vnet/subnets/ci-cd-subnet
```

### import virtual network resource
``` bash
terraform import module.vnet_output.azurerm_virtual_network.local_virtual_network /subscriptions/e1f178b4-040a-4571-b231-1802c3bab7a0/resourceGroups/virtual-machines-group/providers/Microsoft.Network/virtualNetworks/ci-cd-vnet
```


