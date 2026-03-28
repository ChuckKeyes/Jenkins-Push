Full Terraform source code for this project is available in the repository:

terraform-code/
# 1. Cover Page

Include:

- Title: **Final Report – Lab3 & Lab4**
    
- Name: **Charles Keyes Sr.**
    
- Course Name
    
- Instructor
    
- Date
    
- Project name (optional):  
    **Keyes Cloud Solutions Global Infrastructure**
    

---

# 2. Executive Summary

This project demonstrates the design and deployment of a **multi-region hybrid cloud infrastructure** using **Terraform Infrastructure-as-Code** across **Amazon Web Services (AWS)** and **Google Cloud Platform (GCP)**. The objective of Lab3 and Lab4 was to build a scalable and automated global network architecture capable of connecting multiple regions and cloud providers while maintaining secure and reliable connectivity.

The infrastructure includes several key networking components. In AWS, **Virtual Private Clouds (VPCs)** were deployed in the **Tokyo and São Paulo regions**, connected using an **AWS Transit Gateway (TGW)** to provide centralized routing between networks. On the Google Cloud side, VPC networks were deployed in **Iowa and New York**, with connectivity managed through **Google Cloud Network Connectivity Center (NCC)** and **High Availability VPN tunnels**. These components enable secure communication between cloud environments and across geographic regions.

All infrastructure was deployed using **Terraform modules**, allowing consistent and repeatable provisioning of networks, compute resources, and routing components. The deployment process included Terraform initialization, validation, planning, and application to create the required infrastructure resources automatically.

The final architecture successfully established **multi-region connectivity between AWS and GCP environments**, enabling communication between virtual machines located in different cloud providers and regions. Terraform outputs and connectivity testing confirmed that the infrastructure was deployed correctly and that routing between networks was functioning as intended. This project demonstrates practical experience with **hybrid cloud networking, Terraform automation, and multi-region infrastructure design**.
    

---

# 3. Architecture Overview

This project implements a **hybrid multi-region cloud architecture** deployed using **Terraform Infrastructure-as-Code** across **Amazon Web Services (AWS)** and **Google Cloud Platform (GCP)**. The architecture connects multiple cloud regions and networks using centralized routing and secure VPN connectivity, allowing resources located in different regions and cloud providers to communicate with each other.

The design uses **AWS Transit Gateway (TGW)** as the central routing hub for AWS regions and **Google Cloud Network Connectivity Center (NCC)** as the hub for GCP networks. These hubs enable scalable connectivity between multiple Virtual Private Clouds (VPCs) and allow networks to expand without requiring complex point-to-point connections.

Secure connectivity between the AWS and GCP environments is established using **High Availability (HA) VPN tunnels**, which provide encrypted communication between cloud providers. This hybrid architecture enables reliable cross-cloud communication while maintaining secure network boundaries.

---

## Cloud Regions

The infrastructure spans multiple geographic regions across two cloud providers.

### Amazon Web Services (AWS)

|Region|Purpose|
|---|---|
|Tokyo (ap-northeast-1)|Primary AWS infrastructure|
|São Paulo (sa-east-1)|Secondary AWS region connected through Transit Gateway|

### Google Cloud Platform (GCP)

|Region|Purpose|
|---|---|
|Iowa (us-central1)|Test environment and NCC connectivity|
|New York (us-east1)|Remote branch network|

---

## Network Topology

The network architecture uses a **hub-and-spoke model** to simplify routing and improve scalability.

### AWS Network Hub

AWS Transit Gateway serves as the **central hub** connecting AWS VPC networks.

Connected resources include:

- Tokyo VPC
    
- São Paulo VPC
    
- EC2 compute instances
    
- subnet routing tables
    

The Transit Gateway allows multiple AWS VPCs to communicate without requiring direct peering connections between each VPC.

---

### GCP Network Hub

Google Cloud uses **Network Connectivity Center (NCC)** to manage connectivity between networks.

The NCC hub connects:

- Iowa VPC
    
- New York VPC
    
- HA VPN gateways
    
- Cloud Router components
    

This design allows GCP networks to scale easily by adding additional spokes to the NCC hub.

---

### Hybrid Cloud Connectivity

Connectivity between AWS and GCP environments is established using **High Availability VPN tunnels**. These VPN connections provide encrypted communication between the two cloud providers.

Key components include:

- GCP HA VPN Gateway
    
- Cloud Router with BGP
    
- IPSec VPN tunnels
    
- AWS networking components connected through Transit Gateway
    

This configuration enables routing between AWS VPC networks and GCP VPC networks while maintaining secure encrypted traffic between clouds.

---

## Core Components

The architecture includes several key infrastructure components deployed through Terraform.

### Networking Components

- AWS Transit Gateway
    
- AWS VPC networks
    
- GCP VPC networks
    
- Google Cloud Network Connectivity Center (NCC)
    
- HA VPN gateways
    
- Cloud Router with BGP routing
    

---

### Compute Resources

Virtual machines were deployed in both cloud environments to verify connectivity and network routing.

Examples include:

- AWS EC2 instances
    
- GCP Compute Engine virtual machines
    

These instances were used to perform connectivity tests between networks.

---

### Infrastructure Automation

All infrastructure components were deployed using **Terraform modules**, enabling automated provisioning and consistent infrastructure configuration.

Terraform manages:

- VPC creation
    
- subnet configuration
    
- routing tables
    
- VPN gateways
    
- compute instances
    
- connectivity infrastructure
    

Using Terraform ensures that the entire architecture can be recreated reliably using Infrastructure-as-Code.

---

## Architecture Diagram

The following diagram illustrates the high-level architecture of the multi-region hybrid cloud infrastructure.

_(Insert architecture diagram here)_

![](diagrams/lab4-architecture.png)

The diagram shows:

- AWS regions connected through Transit Gateway
    
- GCP regions connected through NCC hub
    
- HA VPN tunnels between cloud providers
    
- Compute instances used for connectivity testing
    

---

## Terraform Project Structure

The Terraform configuration for this project is organized using a modular structure to separate infrastructure components.

Example folder structure:

terraform/  
│  
├── main.tf  
├── providers.tf  
├── variables.tf  
├── outputs.tf  
│  
├── modules/  
│   ├── tokyo_authority  
│   ├── saopaulo_compute  
│   ├── gcp_iowa_network  
│   └── gcp_ny_network

This modular design improves maintainability and allows infrastructure components to be reused across environments.

---

## Screenshots Included in This Section

The following screenshots provide visual confirmation of the architecture design.

- Global architecture diagram
    
- Terraform project folder structure
    

These screenshots help illustrate the structure and connectivity of the deployed infrastructure.

---

# 4. Lab3 Implementation

Lab3 focuses on deploying the **AWS portion of the global infrastructure** using **Terraform modules**. This lab establishes the core AWS networking environment that will later connect to external regions and cloud providers in Lab4.

The infrastructure deployed in this lab includes **VPC networking, EC2 compute instances, and Transit Gateway connectivity between AWS regions**. Terraform was used to automate the provisioning of all resources, allowing the infrastructure to be consistently recreated using Infrastructure-as-Code.

---

# 4.1 Lab3 Objective

The objective of Lab3 was to deploy a **multi-region AWS infrastructure using Terraform modules**. This environment forms the foundation for the global hybrid architecture implemented later in Lab4.

The primary goals of this lab were:

- Deploy **Virtual Private Clouds (VPCs)** in multiple AWS regions
    
- Launch **EC2 compute resources** for testing connectivity
    
- Configure **AWS Transit Gateway** for centralized routing
    
- Establish secure communication between AWS regions
    

The Tokyo region serves as the **primary AWS environment**, while São Paulo acts as a **secondary region connected through the Transit Gateway**.

This architecture provides a scalable foundation for connecting additional networks and cloud providers.

---

# 4.2 Lab3 Architecture

Lab3 deploys AWS infrastructure across multiple geographic regions using a **hub-and-spoke networking model**.

### Regions Used

|Region|Purpose|
|---|---|
|Tokyo (ap-northeast-1)|Primary AWS infrastructure|
|São Paulo (sa-east-1)|Secondary region connected through Transit Gateway|

---

### VPC Design

Each AWS region contains a dedicated **Virtual Private Cloud (VPC)** that hosts compute resources and networking components.

The VPC configuration includes:

- Private networking ranges
    
- Subnets for compute resources
    
- Security groups controlling access
    
- Routing tables for inter-VPC communication
    

These VPCs are connected through the **AWS Transit Gateway**, allowing resources in different regions to communicate securely.

---

### Transit Gateway

The **AWS Transit Gateway (TGW)** acts as the central routing hub connecting the regional VPC networks.

Key benefits of the Transit Gateway include:

- Simplified routing between VPCs
    
- Centralized network control
    
- Scalable multi-region connectivity
    

The Transit Gateway allows the Tokyo and São Paulo VPCs to communicate without requiring direct peering between the VPCs.

---

### Architecture Diagram

The following diagram illustrates the AWS infrastructure deployed in Lab3.

![](diagrams/lab3-Architecture.drawio)

---

### Screenshots Included

The following screenshots provide visual confirmation of the deployed infrastructure.

- AWS VPC console
    
- Transit Gateway configuration
    
- Terraform plan output
    

Example:

![](screenshots/aws/aws-vpc-console.png)

---

# 4.3 Terraform Code Structure

The infrastructure in Lab3 was deployed using **Terraform modules** to separate infrastructure components into reusable units.

This modular approach improves organization and allows infrastructure components to be reused across different environments.

### Terraform Folder Structure

terraform/  
│  
├── main.tf  
├── providers.tf  
├── variables.tf  
├── outputs.tf  
├── terraform.tfvars  
│  
└── modules/  
    ├── tokyo_authority  
    └── saopaulo_compute

---

### Module Design

Two primary Terraform modules were used to deploy the AWS infrastructure.

**tokyo_authority**

This module deploys the core infrastructure in the Tokyo region including:

- VPC
    
- subnets
    
- EC2 compute instance
    
- security groups
    
- Transit Gateway components
    

**saopaulo_compute**

This module deploys infrastructure in the São Paulo region including:

- VPC
    
- compute resources
    
- Transit Gateway attachment
    

---

### Provider Configuration

Terraform providers were configured to deploy infrastructure across multiple AWS regions.

Example configuration:

provider "aws" {  
  region = "ap-northeast-1"  
}  
  
provider "aws" {  
  alias  = "saopaulo"  
  region = "sa-east-1"  
}

Provider aliases allow Terraform to manage resources in multiple regions simultaneously.

---

### Variables and Remote State

Terraform variables were used to define configurable infrastructure settings such as:

- VPC CIDR ranges
    
- instance types
    
- region settings
    

Terraform outputs were also used to export resource identifiers such as:

- VPC IDs
    
- Transit Gateway IDs
    
- EC2 instance information
    

---

### Screenshots Included

- VS Code Terraform project structure
    
- Example Terraform configuration file
    

Example:

![](screenshots/terraform/project-structure.png)

---

# 4.4 Lab3 Deployment Process

The infrastructure was deployed using standard Terraform workflow commands.

### Step 1 – Initialize Terraform

Terraform initialization downloads required providers and modules.

terraform init

---

### Step 2 – Validate Configuration

The configuration was validated to ensure there were no syntax errors.

terraform validate

---

### Step 3 – Generate Deployment Plan

Terraform generated a deployment plan showing all infrastructure resources that would be created.

terraform plan

Example output included creation of:

- VPC networks
    
- subnets
    
- EC2 instances
    
- Transit Gateway attachments
    

---

### Step 4 – Deploy Infrastructure

The infrastructure was deployed using Terraform apply.

terraform apply

After confirmation, Terraform created all AWS resources defined in the configuration files.

---

### Screenshots Included

- Terraform plan output
    
- Terraform apply success message
    

Example:

![](screenshots/terraform/terraform-plan.png)

---

# 4.5 Lab3 Verification

After deployment, the infrastructure was verified using Terraform outputs and AWS console inspection.

### Terraform Outputs

Terraform outputs confirm that the infrastructure was successfully created.

Example outputs include:

tokyo_vpc_id  
saopaulo_vpc_id  
ec2_instance_id  
tgw_id

These outputs provide identifiers for key infrastructure components.

---

### Infrastructure Verification

The following components were verified in the AWS Management Console:

- VPC networks created successfully
    
- EC2 instances running
    
- Transit Gateway attachments active
    
- routing tables configured correctly
    

---

### Screenshots Included

- AWS VPC console
    
- EC2 instances running
    
- Transit Gateway attachments
    
- Terraform output results
    

Example:

![](screenshots/aws/aws-ec2-running.png)

---

# 4.6 Lab3 Summary

Lab3 successfully deployed a multi-region AWS infrastructure using Terraform modules.

The implementation included the creation of VPC networks, EC2 compute resources, and Transit Gateway connectivity between AWS regions. Terraform automation ensured that the infrastructure could be deployed consistently using Infrastructure-as-Code.

Verification of the deployed infrastructure confirmed that the networking components were configured correctly and that resources were running as expected. The modular Terraform design simplified infrastructure management and provided a scalable foundation for future expansion.

The AWS infrastructure deployed in Lab3 serves as the **core environment that will connect to additional cloud networks in Lab4**, enabling the creation of a global hybrid cloud architecture.
---

# 5. Lab4 Implementation

Lab4 expanded the infrastructure created in the previous labs by integrating **Google Cloud Platform (GCP)** networking with the existing **AWS multi-region architecture**. The goal of this lab was to build a **secure multi-cloud network backbone** connecting AWS resources with GCP virtual networks using **HA VPN, BGP routing, and Network Connectivity Center (NCC)**.

---

# 5.1 Lab4 Objective

The objective of Lab4 was to extend the existing AWS infrastructure to support **multi-cloud connectivity**.

This required building secure connectivity between AWS and GCP using enterprise-grade networking components.

Lab4 introduced the following technologies:

- Google Cloud **HA VPN Gateway**
    
- **Cloud Router with BGP dynamic routing**
    
- **Network Connectivity Center (NCC)**
    
- Multi-cloud routing between AWS and GCP
    
- Multiple GCP networks connected through NCC spokes
    

The architecture ensures that workloads deployed in GCP can communicate securely with AWS resources while maintaining a controlled routing environment.

This type of architecture is commonly used in **enterprise hybrid cloud deployments** where multiple cloud providers are connected into a unified network.

The final Lab4 environment successfully connects:

- AWS Tokyo infrastructure
    
- AWS São Paulo infrastructure
    
- GCP Iowa VPC
    
- GCP New York VPC
    

This creates a **multi-cloud transit backbone network**.

This architecture is described in the project documentation as a **multi-cloud transit architecture connecting AWS Transit Gateway and GCP HA VPN through BGP routing**.

Final thoughts

---

# 5.2 Lab4 Architecture

Lab4 integrates AWS and GCP networks using a hub-and-spoke topology.

The architecture consists of the following components:

### AWS Components

Tokyo Region:

- Tokyo VPC
    
- Application Load Balancer
    
- Private EC2 instance
    
- RDS database
    
- Tokyo Transit Gateway
    

São Paulo Region:

- São Paulo VPC
    
- Application EC2 instance
    
- São Paulo Transit Gateway
    

These regions are connected using **Transit Gateway peering**.

### GCP Components

GCP networks were deployed using **Network Connectivity Center (NCC)**.

NCC Hub:

armageddon-ncc-hub

Spokes:

- Iowa VPC  
    CIDR: `10.30.1.0/24`
    
- New York VPC  
    CIDR: `10.40.1.0/24`
    

These networks are connected through a **GCP Transit VPC**, which provides connectivity to AWS using **HA VPN tunnels**.

### VPN Connectivity

The AWS Transit Gateway connects to GCP using **four BGP VPN tunnels** created through an HA VPN gateway.

Example tunnel configuration:

GCP HA VPN Public IPs  
  
interface 0: 34.183.4.150  
interface 1: 35.220.4.33

AWS VPN connections:

vpn-03067e15e97109db4  
vpn-08ebdc9fe060e5592

Each VPN connection contains **two IPSec tunnels**, providing redundancy and high availability.

### Architecture Diagram

Insert screenshot:

lab4-architecture.png

Example architecture flow:

Internet  
   │  
CloudFront + WAF  
   │  
Tokyo ALB  
   │  
Private EC2  
   │  
Tokyo TGW  
   │  
────────── VPN / BGP ──────────  
   │  
GCP HA VPN Gateway  
   │  
Cloud Router  
   │  
GCP Transit VPC  
   │  
NCC Hub  
  /     \  
Iowa   NY

This architecture creates a **secure multi-cloud backbone connecting AWS and GCP networks**.

Final throughts

---

# 5.3 Terraform Infrastructure

Terraform was used to deploy all Lab4 infrastructure components.

Key Terraform resources included:

### GCP Networking

google_compute_network  
google_compute_subnetwork  
google_compute_router  
google_compute_router_interface  
google_compute_router_peer

### VPN Infrastructure

google_compute_ha_vpn_gateway  
google_compute_vpn_tunnel  
google_compute_external_vpn_gateway

### Network Connectivity Center

google_network_connectivity_hub  
google_network_connectivity_spoke

These resources created the **NCC hub-and-spoke architecture** used to connect the Iowa and New York VPCs.

Terraform modules were used to organize the infrastructure code and keep the project structure modular and maintainable.

Example modules used in the project:

modules/  
   gcp_iowa_network  
   gcp_ny_network  
   gcp_transit_vpc  
   gcp_ha_vpn  
   gcp_ncc

Terraform automatically created all networking resources, VPN tunnels, routers, and NCC spokes required for the multi-cloud network.

---

# 5.4 Deployment Steps

The Lab4 infrastructure was deployed using Terraform.

The following commands were executed during deployment:

### Initialize Terraform

terraform init

### Validate configuration

terraform validate

### Generate infrastructure plan

terraform plan

### Apply infrastructure

terraform apply

Terraform automatically provisioned:

- GCP VPC networks
    
- GCP HA VPN gateway
    
- Cloud Router
    
- BGP sessions
    
- NCC hub and spokes
    
- VM instances in Iowa and New York
    
- Routing between AWS and GCP networks
    

Deployment outputs confirmed that all resources were created successfully.

Screenshots included in the documentation:

- Terraform plan output
    
- Terraform apply completion
    
- Terraform outputs
    

---

# 5.5 Connectivity Verification

Connectivity tests were performed to confirm that the multi-cloud network was functioning correctly.

### VPN Tunnel Status

The VPN connections between AWS and GCP were verified using AWS CLI.

Example command:

aws ec2 describe-vpn-connections

### Transit Gateway Peering

The Transit Gateway peering connection between Tokyo and São Paulo was confirmed.

Example:

TransitGatewayAttachmentId:  
tgw-attach-0d242898036bc3ae0

Status:

State: available

This confirms that the AWS regional networks are connected successfully.

### Route Verification

Route tables were checked to confirm that routes were being propagated correctly across the network.

Example:

DestinationCidrBlock: 10.20.0.0/16  
ResourceType: peering  
State: active

### VM Connectivity

The following VMs were successfully deployed:

Iowa VM:

iowa-test-vm01  
IP: 10.30.1.2

New York VM:

ny-branch-vm01  
IP: 10.40.1.2

These instances are reachable across the multi-cloud network.

Terraform outputs confirm their deployment.

Lab4-Deliverables

---

# 5.6 Terraform Outputs

The final Terraform deployment generated several outputs used to verify infrastructure status.

Example outputs:

cloudfront_distribution_id = EUN22J2U2LTO3  
cloudfront_domain_name = do920hzo448ns.cloudfront.net

GCP networking outputs:

gcp_ncc_hub_name = armageddon-ncc-hub  
gcp_ncc_iowa_spoke_id  
gcp_ncc_ny_spoke_id

VM outputs:

iowa_vm_internal_ip = 10.30.1.2  
ny_vm_internal_ip = 10.40.1.2

AWS infrastructure outputs:

saopaulo_vpc_id = vpc-05758ad32619d5288

These outputs confirm that the multi-cloud infrastructure was successfully deployed and configured.

Lab4-Deliverables

---

# 5.7 Lab4 Summary

Lab4 successfully extended the infrastructure to include **multi-cloud networking between AWS and GCP**.

Key accomplishments include:

- Deployment of **GCP HA VPN with BGP routing**
    
- Creation of **Network Connectivity Center hub and spokes**
    
- Integration of **AWS Transit Gateway with GCP VPN infrastructure**
    
- Deployment of GCP virtual machines in Iowa and New York
    
- Successful multi-region routing across AWS and GCP networks
    
- Full Terraform automation of the infrastructure
    

The completed environment now represents a **fully functional multi-cloud enterprise architecture** with secure connectivity between AWS and GCP networks.

This architecture demonstrates the use of advanced cloud networking technologies including **Transit Gateway, HA VPN, BGP routing, and Network Connectivity Center**.

---

# 6. Challenges and Solutions

During the development and deployment of the multi-cloud infrastructure, several technical challenges were encountered. These issues primarily involved Terraform configuration errors, module dependencies, networking configuration problems, and multi-cloud routing complexity.

Each issue was resolved through debugging, code refactoring, and infrastructure verification.

---

# 6.1 Terraform Dependency Errors

### Problem

Terraform reported errors related to **undeclared resources and missing module references** during the planning stage.

Example error:

Error: Reference to undeclared resource

This occurred when Terraform modules referenced resources that were not declared within the module scope.

### Solution

The issue was resolved by correcting module references and ensuring all required resources were defined within their respective Terraform modules.

Module dependencies were clarified by:

- Declaring resources inside the correct module
    
- Passing required values using module variables
    
- Using Terraform outputs to expose required resource identifiers
    

This ensured that Terraform could correctly resolve dependencies between modules.

---

# 6.2 Duplicate Resource Errors

### Problem

Terraform reported duplicate resource definitions during deployment.

Example error:

Resource already managed by Terraform

This occurred when resources were defined multiple times across modules or imported into Terraform state incorrectly.

### Solution

The Terraform configuration was refactored to ensure each resource was declared only once.

Key steps included:

- Removing duplicate resource definitions
    
- Consolidating resource declarations within the appropriate module
    
- Cleaning the Terraform state when necessary
    

This allowed Terraform to manage infrastructure resources without conflicts.

---

# 6.3 Provider Alias Conflicts

### Problem

The project used multiple AWS regions and GCP infrastructure, which required provider aliases. Incorrect provider configuration caused Terraform to deploy resources in the wrong region.

Example configuration challenge:

provider "aws" {  
  alias  = "use1"  
  region = "us-east-1"  
}

If modules did not explicitly reference the correct provider alias, resources could be created in unintended regions.

### Solution

Provider aliases were implemented for all required regions.

Example providers used in the project:

aws.ap-northeast-1  
aws.saopaulo  
aws.use1

Modules were updated to reference the correct provider configuration, ensuring resources were deployed to the correct cloud region.

---

# 6.4 Multi-Cloud Networking Complexity

### Problem

Connecting AWS and GCP networks required coordinating multiple networking components including:

- AWS Transit Gateway
    
- GCP HA VPN
    
- Cloud Router
    
- BGP routing
    
- Network Connectivity Center
    

Initial routing configuration errors prevented networks from communicating correctly.

### Solution

The network architecture was reviewed and routing tables were verified on both cloud platforms.

Key steps included:

- Verifying BGP configuration
    
- Confirming VPN tunnel status
    
- Validating route propagation across Transit Gateway
    
- Ensuring CIDR ranges were correctly advertised
    

Once routing propagation was confirmed, connectivity between AWS and GCP networks was successfully established.

---

# 6.5 Terraform Module Organization

### Problem

The Terraform project contained **hundreds of files**, making the infrastructure difficult to manage.

This complexity made debugging and navigation more difficult during development.

### Solution

Terraform modules were introduced to organize infrastructure components into logical units.

Example module structure:

modules/  
   tokyo_authority  
   saopaulo_compute  
   gcp_iowa_network  
   gcp_ny_network  
   gcp_ncc

This modular design improved code readability, reuse, and maintainability.

---

# 6.6 Network Connectivity Troubleshooting

### Problem

During testing, some services initially failed to communicate across regions.

Examples included:

- Application servers unable to reach databases
    
- VPN tunnels not establishing correctly
    
- Routing tables missing required CIDR entries
    

### Solution

Connectivity was verified using command-line tools and cloud provider diagnostics.

Example verification commands:

aws ec2 describe-transit-gateways  
aws ec2 describe-vpn-connections  
gcloud compute vpn-tunnels list

These commands confirmed that:

- VPN tunnels were active
    
- Transit Gateway attachments were available
    
- Route tables contained the correct CIDR entries
    

Once routing propagation was confirmed, network communication between AWS and GCP environments functioned correctly.

---

# 6.7 Summary of Challenges

The major challenges encountered during the project included:

- Terraform dependency errors
    
- Duplicate resource definitions
    
- Provider alias conflicts
    
- Multi-cloud networking complexity
    
- Large Terraform codebase organization
    
- Network routing configuration
    

Each issue was resolved through systematic debugging, improved Terraform module design, and network verification procedures.

These troubleshooting efforts helped ensure the successful deployment of the **multi-cloud infrastructure architecture** used throughout the lab environment.

---

# 7. Lessons Learned

The development of this multi-cloud infrastructure project provided valuable experience in cloud architecture, networking design, and infrastructure automation. Several important lessons were learned during the implementation of the AWS and Google Cloud environment.

These lessons highlight both the technical and architectural considerations required when building large-scale cloud infrastructure.

---

# 7.1 Terraform Module Design

One of the most important lessons from this project was the value of **modular Terraform design**.

Initially, managing a large Terraform configuration with many files became difficult as the infrastructure expanded. By organizing the infrastructure into modules, the project became easier to manage and maintain.

Examples of Terraform modules used in the project include:

modules/  
   tokyo_authority  
   saopaulo_compute  
   gcp_iowa_network  
   gcp_ny_network  
   gcp_ncc

Using modules allowed the infrastructure to be separated into logical components such as networking, compute resources, and connectivity. This approach improved code readability and made it easier to reuse infrastructure components across different regions.

The project demonstrated that modular Terraform architecture is essential for managing complex cloud environments.

---

# 7.2 Multi-Cloud Networking

Another key lesson was understanding the complexity involved in **multi-cloud networking**.

Connecting AWS and Google Cloud required careful configuration of several networking components, including:

- AWS Transit Gateway
    
- GCP HA VPN Gateway
    
- Cloud Router
    
- Network Connectivity Center (NCC)
    
- BGP dynamic routing
    

These technologies allowed the AWS and GCP environments to exchange routes and communicate securely across cloud providers.

The project demonstrated how multi-cloud networking can create a unified infrastructure that connects multiple regions and cloud platforms.

---

# 7.3 Transit Gateway Routing

The AWS **Transit Gateway (TGW)** played a critical role in the architecture.

Transit Gateway acted as the central networking hub within the AWS environment. It enabled connectivity between the Tokyo and São Paulo regions through TGW peering.

Routing tables within the Transit Gateway were used to control how traffic moved between VPCs and across regions. Proper route propagation and CIDR configuration were necessary to ensure that traffic flowed correctly across the network.

This lab demonstrated how Transit Gateway simplifies complex network architectures by acting as a central routing hub.

---

# 7.4 Infrastructure Automation

A major takeaway from this project was the power of **Infrastructure as Code (IaC)** using Terraform.

Instead of manually configuring cloud resources, Terraform allowed the entire infrastructure to be defined in code. This enabled repeatable deployments and reduced the risk of configuration errors.

Using Terraform also provided several operational benefits:

- Consistent infrastructure deployments
    
- Version-controlled infrastructure configuration
    
- Automated provisioning of networking and compute resources
    
- Simplified infrastructure management
    

The ability to deploy complex multi-cloud infrastructure using Terraform demonstrated the effectiveness of infrastructure automation in modern cloud environments.

---

# 7.5 Overall Project Insight

This project provided hands-on experience with real-world cloud infrastructure design. By integrating AWS and GCP environments through secure networking and automation, the lab demonstrated how modern enterprise infrastructure can be deployed and managed using infrastructure-as-code principles.

The lessons learned during this project will be valuable for future cloud engineering work involving large-scale distributed systems and multi-cloud environments.
    

---

# 8. Final Results

The completion of Labs 1 through 4 resulted in a fully functional **multi-region and multi-cloud infrastructure environment** built entirely using Terraform. The final architecture integrates services across AWS and Google Cloud Platform while maintaining secure networking and centralized infrastructure automation.

This project demonstrates how modern cloud infrastructure can be deployed using **Infrastructure as Code (IaC)** to create scalable, secure, and repeatable cloud environments.

---

# 8.1 Global Infrastructure Deployment

The final infrastructure includes resources deployed across multiple cloud regions and providers.

### AWS Infrastructure

AWS resources were deployed primarily in the following regions:

- **Tokyo (ap-northeast-1)**
    
- **São Paulo (sa-east-1)**
    

Key AWS components include:

- Virtual Private Clouds (VPCs)
    
- Public and private subnets
    
- Internet Gateway and NAT Gateway
    
- Application Load Balancer
    
- EC2 compute instances
    
- Amazon RDS database
    
- AWS Transit Gateway
    
- Transit Gateway peering between regions
    
- CloudFront with WAF for global edge access
    

These components provide the core compute, networking, and data services for the application infrastructure.

---

# 8.2 Multi-Region Connectivity

The AWS environment supports secure communication between multiple regions using **Transit Gateway peering**.

The Tokyo region functions as the primary infrastructure hub, hosting the core application components and database services. The São Paulo region provides additional compute resources and is connected to Tokyo through the Transit Gateway backbone.

Example regional network ranges used in the architecture:

Tokyo VPC:       10.10.0.0/16  
São Paulo VPC:   10.20.0.0/16

Transit Gateway route tables were configured to allow secure routing between these regions while maintaining controlled network segmentation.

---

# 8.3 Multi-Cloud Connectivity

The architecture was extended to include Google Cloud Platform networks connected to AWS through a secure VPN infrastructure.

The GCP environment includes:

- Iowa VPC  
    CIDR: `10.30.1.0/24`
    
- New York VPC  
    CIDR: `10.40.1.0/24`
    

These networks are connected through a **Network Connectivity Center (NCC) hub-and-spoke topology**, which allows centralized network management.

Connectivity between AWS and GCP is achieved through:

- GCP HA VPN Gateway
    
- AWS Site-to-Site VPN
    
- Cloud Router with BGP dynamic routing
    

This configuration enables secure route exchange between the two cloud providers.

Example GCP virtual machine deployments include:

iowa-test-vm01  
10.30.1.2  
  
ny-branch-vm01  
10.40.1.2

These systems confirm that the GCP networks were successfully deployed and integrated into the architecture.

---

# 8.4 Terraform Infrastructure Automation

All infrastructure components across AWS and GCP were deployed using Terraform.

Terraform configuration files defined resources such as:

- VPC networks
    
- Subnets
    
- VPN gateways
    
- Transit Gateway attachments
    
- Virtual machines
    
- Load balancers
    
- Routing configuration
    

Terraform modules were used to organize the infrastructure into reusable components.

Example module structure:

modules/  
   tokyo_authority  
   saopaulo_compute  
   gcp_iowa_network  
   gcp_ny_network  
   gcp_ncc

Terraform commands used during deployment included:

terraform init  
terraform validate  
terraform plan  
terraform apply

Using Terraform ensured that the infrastructure could be deployed consistently and reproduced when needed.

---

# 8.5 Verified Infrastructure Outputs

Terraform outputs confirmed that the infrastructure was deployed successfully.

Example outputs include:

cloudfront_distribution_id = EUN22J2U2LTO3  
cloudfront_domain_name     = do920hzo448ns.cloudfront.net

Virtual machine outputs:

iowa_vm_internal_ip = 10.30.1.2  
ny_vm_internal_ip   = 10.40.1.2

Network connectivity outputs:

gcp_ncc_hub_name = armageddon-ncc-hub

These outputs verify that all infrastructure components were successfully provisioned and operational.

---

# 8.6 Overall System Status

The final infrastructure environment demonstrates a fully operational **multi-region and multi-cloud architecture**.

The completed system includes:

- AWS regional infrastructure in Tokyo and São Paulo
    
- Secure multi-region routing through Transit Gateway
    
- GCP networks connected through Network Connectivity Center
    
- HA VPN connectivity between AWS and GCP
    
- Infrastructure automation using Terraform modules
    
- Global edge access through CloudFront
    

---

# 9. Conclusion

This project demonstrated the design and deployment of a **multi-region and multi-cloud infrastructure architecture** using modern cloud engineering practices. Across Labs 1 through 4, a complete infrastructure environment was built that integrates services from both **Amazon Web Services (AWS)** and **Google Cloud Platform (GCP)** while maintaining secure networking, centralized routing, and automated infrastructure provisioning.

The architecture was designed to simulate the type of infrastructure used by large organizations that operate across multiple geographic regions and cloud providers. Using **Terraform Infrastructure as Code**, the project successfully automated the deployment of networking resources, compute instances, routing infrastructure, and security components across multiple cloud environments.

The AWS portion of the architecture was centered in the **Tokyo region**, which served as the primary infrastructure hub hosting core application services and the relational database. Additional compute capacity was deployed in the **São Paulo region**, connected through **AWS Transit Gateway peering** to create a secure multi-region network corridor. This configuration allowed application components to operate across regions while maintaining centralized data storage.

The infrastructure was further expanded by integrating **Google Cloud Platform networks** through a secure VPN architecture. Using **HA VPN, Cloud Router, and BGP dynamic routing**, the AWS environment was connected to a **Network Connectivity Center (NCC) hub-and-spoke network** that linked additional virtual networks located in Iowa and New York. This created a fully functional **multi-cloud backbone network** capable of routing traffic between AWS and GCP environments.

Throughout the project, Terraform modules were used to organize infrastructure components into reusable and maintainable configurations. This modular design approach allowed the infrastructure to scale while maintaining clear separation between networking, compute resources, and connectivity components.

Verification steps confirmed that the infrastructure was functioning correctly. Transit Gateway routing tables were validated, VPN tunnels were successfully established, and virtual machines deployed in multiple regions were reachable through the configured network paths. Terraform outputs further confirmed that all required resources were provisioned successfully.

Beyond the technical implementation, the project highlighted the importance of **infrastructure automation, network design, and multi-cloud connectivity** in modern cloud engineering environments. By using Infrastructure as Code, the entire environment can be reproduced consistently, enabling repeatable deployments and improved operational reliability.

The final architecture represents a **realistic enterprise-style cloud infrastructure** that demonstrates key concepts including multi-region networking, hybrid cloud connectivity, centralized routing, and automated infrastructure deployment. These capabilities are essential in modern distributed systems where reliability, scalability, and security are critical design considerations.

Overall, this project provided valuable hands-on experience with advanced cloud networking technologies and infrastructure automation tools. The skills developed through this work—including Terraform module design, multi-cloud network architecture, and infrastructure verification—are directly applicable to real-world cloud engineering and DevOps environments.

The completion of this project demonstrates the ability to design, deploy, and manage complex cloud infrastructure systems using modern infrastructure engineering practices.






# 10. Appendix

This appendix provides supporting materials and evidence used during the development and verification of the multi-cloud infrastructure environment. These materials include Terraform outputs, configuration files, architecture diagrams, and infrastructure verification screenshots.

All supporting materials are organized within the project repository.

---

# Appendix A – Terraform Outputs

Terraform outputs confirm that the infrastructure was successfully deployed and that key resources were created across AWS and Google Cloud Platform.

Example outputs include:

cloudfront_distribution_id  
cloudfront_domain_name  
gcp_ncc_hub_name  
iowa_vm_internal_ip  
ny_vm_internal_ip  
saopaulo_vpc_id

Screenshots showing Terraform execution and outputs are located in the following directory:

screenshots/terraform/

Key Terraform execution screenshots include:

terraform-init.png  
terraform-validate.png  
terraform-plan.png  
terraform-apply.png  
terraform-outputs.png

These screenshots provide verification that the Terraform deployment completed successfully.

---

# Appendix B – Key Terraform Files

Terraform configuration files used in the project are located in the following directory:

terraform-code/

These files define the infrastructure resources deployed across AWS and Google Cloud Platform.

Key Terraform configuration components include:

main.tf  
providers.tf  
variables.tf  
outputs.tf  
terraform.tfvars

Terraform modules used within the project include infrastructure definitions for:

- AWS Tokyo infrastructure
    
- AWS São Paulo infrastructure
    
- GCP Iowa network
    
- GCP New York network
    
- Network Connectivity Center configuration
    
- VPN connectivity between AWS and GCP
    

These configuration files enable the infrastructure to be deployed using Infrastructure as Code.

---

# Appendix C – Architecture Diagrams

Architecture diagrams used throughout the report are stored in the following directories:

architecture-diagrams/  
diagrams/

Key diagrams include:

Lab3-Architecture.drawio  
lab4-architecture.png

These diagrams illustrate the multi-region and multi-cloud infrastructure deployed during the project.

---

# Appendix D – Infrastructure Verification Screenshots

Screenshots from AWS and Google Cloud consoles provide visual confirmation that infrastructure resources were successfully created.

### AWS Console Screenshots

Located in:

screenshots/aws/

Examples include:

aws-vpc-console.png  
aws-subnets.png  
aws-security-groups.png  
aws-ec2-running.png  
aws-transit-gateway.png

These screenshots confirm that AWS networking and compute resources were deployed successfully.

---

### Google Cloud Console Screenshots

Located in:

screenshots/gcp/

Examples include:

gcp-vpc-network.png  
gcp-vm-instances.png  
gcp-ncc-hub.png  
gcp-ncc-spokes.png  
gcp-vpn-status.png  
BGP-VPN.png

These screenshots confirm that GCP networking resources, VPN tunnels, and NCC hub-and-spoke architecture were successfully configured.

---

# Appendix E – Terraform Project Structure

A screenshot showing the Terraform project structure is included to demonstrate how the infrastructure code was organized.

Location:

screenshots/terraform/project-structure.png

This screenshot illustrates the modular design used to organize Terraform infrastructure components.
---
