📄 folder_structure.md
markdown
Copy
Edit
# 🗂️ Terraform Folder Structure Setup for `quotes-app`

This script creates the following folder structure for a Terraform-based `quotes-app` project:

quotes-app/
├── main.tf
├── variables.tf
├── modules/
│ ├── dynamodb/
│ │ └── main.tf
│ ├── lambda/
│ │ └── main.tf
│ └── apigateway/
│ └── main.tf

bash
Copy
Edit

---

## 📜 Script: `folder_structure.sh`

```bash
#!/bin/bash

# Create main project directory
mkdir -p quotes-app

# Create top-level Terraform files
touch quotes-app/main.tf
touch quotes-app/variables.tf

# Create module directories and their main.tf files
mkdir -p quotes-app/modules/dynamodb
touch quotes-app/modules/dynamodb/main.tf

mkdir -p quotes-app/modules/lambda
touch quotes-app/modules/lambda/main.tf

mkdir -p quotes-app/modules/apigateway
touch quotes-app/modules/apigateway/main.tf

echo "✅ Folder structure for 'quotes-app' created successfully!"
🚀 How to Use
Save the script as folder_structure.sh.

Make it executable:

bash
Copy
Edit
chmod +x folder_structure.sh
Run the script:

bash
Copy
Edit
./folder_structure.sh
✅ Next Steps
You can now begin adding your Terraform configurations in:

Root: main.tf, variables.tf

Modules: dynamodb/main.tf, lambda/main.tf, apigateway/main.tf
