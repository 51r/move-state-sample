# Terraform State Move Sample

This repo contains simple code with two resources. The goal is to separate the two resources in different modules and separate the state.

# Prerequisite
You need to have [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed on you workstation. 

# How to use the repo
* Clone this repo locally to a folder of your choice
```
git clone https://github.com/51r/move-state-sample.git
```

* Make sure you are in the main directory of the repo:
```
cd move-state-sample
```

* initialize Terraform  
```
terraform init
```

* Check the plan in order to see the changes which terraform is going to made.
```
terraform plan
```

* Apply the plan which terraform is going to execute based on our configuration (main.tf)
```
terraform apply
```
* Check the Terraform state:
```
terraform state list
```

* Once you make sure that the terraform resources are deployed, you can now separate the random_pet resource into module in subdirectory and specify it in the code as a module.
```
module "random_pet" {
  source = "./module"
}
```

*  After you have specified the module, replace the var in the null_resource, to be using the output of the module and you can initialize the Terraform again.
```
resource "null_resource" "hello" {
  provisioner "local-exec" {
    command = "echo Hello ${module.random_pet.id}"
  }
}
```

* Move the state by using `terraform state mv` command, which you can read more for it [here](https://www.terraform.io/docs/commands/state/mv.html)

In my case I have used the following command `terraform state mv random_pet.pet module.random_pet.random_pet.pet`

You should receive the following output: 
```
Move "random_pet.pet" to "module.random_pet.random_pet.pet"
Successfully moved 1 object(s).
```

* Apply the plan again and the plan should output that there is nothing to be created/deleted.
```
% terraform apply
module.random_pet.random_pet.pet: Refreshing state... [id=partially-legal-grouse]
null_resource.hello: Refreshing state... [id=6997077296683255449]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration 
and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

* Destroy the Terraform configuration resources by executing `terraform destroy`. It should destroy the two resources.
```
% terraform destroy
module.random_pet.random_pet.pet: Refreshing state... [id=partially-legal-grouse]
null_resource.hello: Refreshing state... [id=6997077296683255449]

Terraform used the selected providers to generate the following execution plan. 
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.hello will be destroyed
  - resource "null_resource" "hello" {
      - id = "6997077296683255449" -> null
    }

  # module.random_pet.random_pet.pet will be destroyed
  - resource "random_pet" "pet" {
      - id        = "partially-legal-grouse" -> null
      - length    = 3 -> null
      - separator = "-" -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.
```


**I have included a folder "result" which contains the final result from the task above.**
