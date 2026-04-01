###Snowflake Infrastructure as Code (IaC) with Terraform###

This repository manages the end-to-end lifecycle of Snowflake infrastructure using Terraform. The project is designed to be environment-aware, scalable, and secure, utilizing a modular architecture to handle multi-layered data platforms (Raw, Trans, Analytics).

🚀 Key Features
Key-Pair Authentication: Secure, passwordless connection to Snowflake.

Multi-Provider Architecture: Utilizing multiple provider aliases to perform actions as different Snowflake roles (ACCOUNTADMIN, SYSADMIN, SECURITYADMIN) within the same session.

Environment Isolation: Leveraging Terraform Workspaces (e.g., dev, prod) to manage separate environments with a single codebase.

Dynamic Resource Provisioning: Heavy use of for_each, count, and flatten logic to create resources based on configuration maps rather than hardcoding.


.
├── main.tf                         # Root module calling children
├── provider.tf                     # Multi-role provider configuration
├── var.tf                          # Input variable definitions
├── modules/
   ├── db/                         # Creates RAW, TRANS DBs
   ├── schema/                     # Dynamic schema creation (api, pg, harmonized)
   ├── wh/                         # Compute resource management
   ├── user/                       # user creation
   ├── acc_roles/                  # account role creation
   ├── acc_roles_grants/            # account roles grants
   └── acc_roles_grants_privilege/  # RBAC - Privileges for roles and users