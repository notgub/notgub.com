# AWS CloudFormation Deployment

This directory contains CloudFormation templates and deployment scripts for the web service infrastructure.

## Structure

```
aws-resource/
├── deploy.sh                    # Main deployment script
├── templates/
│   └── ecs-services/
│       └── template.yaml        # ECS service CloudFormation template
├── parameters/
│   ├── dev.json                 # Development environment parameters
│   ├── staging.json             # Staging environment parameters
│   └── prod.json                # Production environment parameters
└── README.md                    # This file
```

## Prerequisites

1. **AWS CLI**: Install and configure AWS CLI
   ```bash
   # Install AWS CLI (if not already installed)
   brew install awscli  # macOS
   
   # Configure AWS credentials
   aws configure
   ```

2. **AWS Permissions**: Ensure your AWS user/role has the following permissions:
   - `cloudformation:*`
   - `ecs:*`
   - `ec2:*`
   - `elasticloadbalancing:*`
   - `iam:CreateRole`
   - `iam:AttachRolePolicy`

## Usage

### Basic Deployment

```bash
# Deploy to development environment (default)
./deploy.sh

# Deploy to specific environment
./deploy.sh -e staging
./deploy.sh -e prod

# Deploy with custom stack name
./deploy.sh -s my-custom-stack -e prod
```

### Other Operations

```bash
# Validate template only
./deploy.sh -v

# Delete stack
./deploy.sh -d -s my-stack-name

# Use specific AWS profile
./deploy.sh -p my-aws-profile

# Deploy to different region
./deploy.sh -r us-west-2
```

### Script Options

- `-s, --stack-name NAME`: Stack name (default: web-service-stack)
- `-t, --template FILE`: Template file (default: templates/ecs-services/template.yaml)
- `-e, --environment ENV`: Environment (dev|staging|prod) (default: dev)
- `-r, --region REGION`: AWS region (default: ap-southeast-7)
- `-p, --profile PROFILE`: AWS profile to use
- `-v, --validate`: Validate template only
- `-d, --delete`: Delete the stack
- `-h, --help`: Show help message

## Parameters

The deployment uses environment-specific parameter files located in the `parameters/` directory:

- `parameters/dev.json` - Development environment
- `parameters/staging.json` - Staging environment  
- `parameters/prod.json` - Production environment

### Parameter Structure

Each parameter file contains:
- `ECSClusterName`: Name of the ECS cluster
- `VpcID`: VPC ID where resources will be deployed
- `ECSServiceName`: Name of the ECS service
- `SecurityGroupIDs`: Security group IDs (comma-separated)
- `SubnetIDs`: Subnet IDs (comma-separated)
- `LoadBalancerName`: Name of the Application Load Balancer

### Customizing Parameters

To customize parameters for your environment:

1. Edit the appropriate parameter file in `parameters/`
2. Update the values to match your AWS resources
3. Run the deployment script

Example:
```json
[
  {
    "ParameterKey": "ECSClusterName",
    "ParameterValue": "my-custom-cluster"
  },
  {
    "ParameterKey": "VpcID",
    "ParameterValue": "vpc-12345678"
  }
]
```

## Template Details

The CloudFormation template (`templates/ecs-services/template.yaml`) creates:

- **ECS Cluster**: Fargate-based cluster for running containers
- **ECS Service**: Service definition for the web application
- **Application Load Balancer**: ALB for traffic distribution
- **Target Group**: Target group for the ALB
- **Listener**: HTTP listener on port 80

## Troubleshooting

### Common Issues

1. **"No updates are to be performed"**
   - This is normal when the stack is already up to date
   - The script will show the current stack status

2. **"Parameters file not found"**
   - Ensure the parameter file exists for your environment
   - Check the file path in the error message

3. **"Template validation failed"**
   - Check the CloudFormation template syntax
   - Ensure all required parameters are defined

4. **"Access denied"**
   - Verify AWS credentials are configured correctly
   - Check that your user/role has sufficient permissions

### Getting Help

```bash
# Show script help
./deploy.sh -h

# Validate template
./deploy.sh -v

# Check stack status
aws cloudformation describe-stacks --stack-name your-stack-name
```

## Security Notes

- Never commit sensitive information (passwords, keys) to version control
- Use AWS IAM roles and policies for access control
- Consider using AWS Systems Manager Parameter Store for sensitive parameters
- Regularly rotate AWS access keys 