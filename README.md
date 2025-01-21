# terraform-oci-arch-asp-net

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=oracle-devrel_terraform-oci-arch-tomcat-autonomous)](https://sonarcloud.io/dashboard?id=oracle-devrel_terraform-oci-arch-tomcat-autonomous)

For details of the architecture, see [_Deploy highly available ASP.Net applications on Oracle Cloud Infrastructure_](https://docs.oracle.com/en/solutions/deploy-an-oci/index.html)

![](./images/ha-aspnet-oci-arch.png)

## Introduction

This repository provides a minimal example of how to quickly setup an automated deployment pipeline for ASP .NET applications on Oracle Cloud Infrastructure. Here we showcase a simple ASP .NET application, and provide the scaffolding to 
- Create the target infrastructure using automation 
- Automate the build process based on source control triggers
- Deploy the application after a build to the target infrastructure. 

## The Example Application

The example application is a simple ASP.NET sample that can be replaced with your own applications of any complexity. The processes to automate the build and the deployment of the application remains the same and is the core focus of this project.

## Build and Deployment Automation

To demonstrate build and deployment automation while keeping dependencies to a minimum, this project uses GitHub workflows as the build and deployment tool. The same processes or commands can be executed from any build and deployment system to get similar results.
In this example, the build is triggered by a commit to the repository or a pull request. The workflow when triggered, will build the application. The built binaries are packaged and terraform is started to update the infrastructure and deploy the application. The OCI API key are managed as GitHub secrets. 

### Authenticating against your own Tenancy

Once you clone this repository, you need to configure your API keys before you can successfully deploy an application on to your own tenancy. These API keys lets the automation authenticate against your tenancy and perform the deployment of infrastructure resources or applications. Once you cone this repository, perform these steps to setup your API key :
- Navigate to **Settings > Secrets** 
- Click on **New Repository Secret**
- Add your OCI key as `OCI_KEY_FILE`
- Update the `terraform.tfvars` file with your tenancy information.

## Infrastructure Automation

This project uses Terraform and Oracle Resource Manager, a service on OCI that can manage your terraform based deployments for development teams. While the use of Resource Manager is optional, it is highly recommended for development teams. 
The infrastructure is expressed as code and terraform, through the Oracle resource manager, creates, updates or destroys the infrastructure components based on the configurations expresses though the terraform code.  This also implicitly version controls infrastructure changes as well, making it easier to track changes to infrastructure and the associated code changes (since infrastructure is managed as code). 

### Deploy Using Oracle Resource Manager

To deploy this solution using Oracle Resource Manager, click on the deployment button below to start the deployment in your oracle cloud infrastructure tenancy.

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/terraform-oci-arch-asp-net/releases/latest/download/terraform-oci-arch-asp-net-stack-latest.zip)

Alternatively, you can download the stack for this solution from the **Releases** a section of this repository. Navigate to Oracle resource manager in the Oracle Cloud Infrastructure console. Here import the zip file as a new resource manager stack. You can now perform terraform actions like plan or apply.

### Deploy Using the Terraform CLI

#### Clone the Module

Now, you'll want a local copy of this repo. You can make that with the commands:

```
    git clone https://github.com/oracle-devrel/terraform-oci-arch-asp-net.git
    cd terraform-oci-arch-asp-net/
    ls
```

#### Prerequisites
First off, you'll need to do some pre-deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Create a `terraform.tfvars` file, and specify the following variables:

```
# Authentication
tenancy_ocid         = "<tenancy_ocid>"
user_ocid            = "<user_ocid>"
fingerprint          = "<finger_print>"
private_key_path     = "<pem_private_key_path>"

# Region
region = "<oci_region>"

# Compartment
compartment_ocid = "<compartment_ocid>"

# instance_password
instance_password = "<instance_password>"

```

#### Create the Resources
Run the following commands:

    terraform init
    terraform plan
    terraform apply


#### Testing your Deployment
After the deployment is finished, you can access the test ASP.NET Application using the loadbalancer IP address which is created as an output key called lb_public_ip.

````
lb_public_ip = 193.122.198.19

`````

Then copy it into Web browser. Here is the example of the succesfull outcome:

![](./images/app_in_browser.png)

### Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy the resources:

    terraform destroy

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## Attribution & Credits
Initially, this project was created and distributed in [GitHub Oracle QuickStart space](https://github.com/oracle-quickstart/oci-asp-net). For that reason, we would like to thank all the involved contributors enlisted below:
- vrmurthy (https://github.com/vrmurthy)
- Jeevan Joseph (https://github.com/jeevanjoseph) 
- Lukasz Feldman (https://github.com/lfeldman)
- Hassan Ajan (https://github.com/haj)
- Ben Lackey (https://github.com/benofben)


## License
Copyright (c) 2024 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE.txt) for more details.