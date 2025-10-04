#!/bin/bash

# CloudFormation Deployment Script for ECS Service
# Usage: ./deploy.sh [options]

set -e

# Default values
STACK_NAME="notgub-website-stack"
TEMPLATE_FILE="templates/ecs-services.yaml"
ENVIRONMENT="dev"
REGION="ap-southeast-7"
PROFILE=""
PARAMETERS_FILE="parameters/${ENVIRONMENT}.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print usage
usage() {
    echo -e "${BLUE}Usage: $0 [OPTIONS]${NC}"
    echo ""
    echo "Options:"
    echo "  -s, --stack-name NAME     Stack name (default: example-stack)"
    echo "  -t, --template FILE       Template file (default: templates/ecs-services/template.yaml)"
    echo "  -e, --environment ENV     Environment (dev|staging|prod) (default: dev)"
    echo "  -r, --region REGION       AWS region (default: ap-southeast-7)"
    echo "  -p, --profile PROFILE     AWS profile to use"
    echo "  -v, --validate            Validate template only"
    echo "  -d, --delete              Delete the stack"
    echo "  -h, --help                Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Deploy with defaults"
    echo "  $0 -s my-stack -e prod               # Deploy to production"
    echo "  $0 -v                                # Validate template only"
    echo "  $0 -d -s my-stack                    # Delete stack"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--stack-name)
            STACK_NAME="$2"
            shift 2
            ;;
        -t|--template)
            TEMPLATE_FILE="$2"
            shift 2
            ;;
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -r|--region)
            REGION="$2"
            shift 2
            ;;
        -p|--profile)
            PROFILE="$2"
            shift 2
            ;;
        -v|--validate)
            VALIDATE_ONLY=true
            shift
            ;;
        -d|--delete)
            DELETE_STACK=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            exit 1
            ;;
    esac
done

# Build AWS CLI command with profile if specified
AWS_CMD="aws"
if [ ! -z "$PROFILE" ]; then
    AWS_CMD="aws --profile $PROFILE"
fi

# Add region to AWS command
AWS_CMD="$AWS_CMD --region $REGION"

# Function to print colored output
print_status() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if stack exists
stack_exists() {
    $AWS_CMD cloudformation describe-stacks --stack-name "$STACK_NAME" >/dev/null 2>&1
}

# Function to validate template
validate_template() {
    print_status "Validating CloudFormation template: $TEMPLATE_FILE"
    
    if [ ! -f "$TEMPLATE_FILE" ]; then
        print_error "Template file not found: $TEMPLATE_FILE"
        exit 1
    fi
    
    if $AWS_CMD cloudformation validate-template --template-body file://"$TEMPLATE_FILE" >/dev/null 2>&1; then
        print_success "Template validation successful"
        return 0
    else
        print_error "Template validation failed"
        return 1
    fi
}

# Function to handle failed stack states
handle_failed_stack() {
    local stack_status=$1
    
    case $stack_status in
        "UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS")
            print_error "Stack is currently cleaning up from a failed update. Please wait for cleanup to complete."
            print_status "You can monitor the status with:"
            echo "  aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].StackStatus'"
            print_status "Or continue monitoring with:"
            echo "  aws cloudformation wait stack-update-rollback-complete --stack-name $STACK_NAME"
            return 1
            ;;
        "UPDATE_ROLLBACK_COMPLETE"|"UPDATE_ROLLBACK_FAILED")
            print_status "Stack is in a rollback state. You can continue with updates."
            return 0
            ;;
        "CREATE_FAILED"|"DELETE_FAILED")
            print_error "Stack is in a failed state. You may need to delete and recreate it."
            print_status "To delete the stack:"
            echo "  aws cloudformation delete-stack --stack-name $STACK_NAME"
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

# Function to deploy stack
deploy_stack() {
    print_status "Deploying CloudFormation stack: $STACK_NAME"
    print_status "Template: $TEMPLATE_FILE"
    print_status "Parameters: $PARAMETERS_FILE"
    print_status "Environment: $ENVIRONMENT"
    print_status "Region: $REGION"
    echo ""
    
    # Check if parameters file exists
    if [ ! -f "$PARAMETERS_FILE" ]; then
        print_error "Parameters file not found: $PARAMETERS_FILE"
        exit 1
    fi
    
    # Validate template first
    if ! validate_template; then
        exit 1
    fi
    
    # Check if stack exists and get its status
    if stack_exists; then
        local stack_status=$($AWS_CMD cloudformation describe-stacks \
            --stack-name "$STACK_NAME" \
            --query 'Stacks[0].StackStatus' \
            --output text 2>/dev/null)
        
        print_status "Current stack status: $stack_status"
        
        # Handle failed stack states
        if ! handle_failed_stack "$stack_status"; then
            exit 1
        fi
        
        print_status "Stack '$STACK_NAME' already exists. Updating..."
        OPERATION="update-stack"
    else
        print_status "Stack '$STACK_NAME' does not exist. Creating..."
        OPERATION="create-stack"
    fi
    
    # Deploy the stack
    if $AWS_CMD cloudformation $OPERATION \
        --stack-name "$STACK_NAME" \
        --template-body file://"$TEMPLATE_FILE" \
        --parameters file://"$PARAMETERS_FILE" \
        --capabilities CAPABILITY_NAMED_IAM \
        --tags Key=Environment,Value="$ENVIRONMENT" Key=Project,Value=example-service 2>&1; then
        
        print_success "Stack deployment initiated successfully"
        
        # Wait for stack to complete
        print_status "Waiting for stack operation to complete..."
        $AWS_CMD cloudformation wait stack-$([ "$OPERATION" = "create-stack" ] && echo "create" || echo "update")-complete --stack-name "$STACK_NAME"
        
        if [ $? -eq 0 ]; then
            print_success "Stack operation completed successfully"
            
            # Display stack outputs
            print_status "Stack outputs:"
            $AWS_CMD cloudformation describe-stacks \
                --stack-name "$STACK_NAME" \
                --query 'Stacks[0].Outputs' \
                --output table
        else
            print_error "Stack operation failed"
            exit 1
        fi
    else
        # Capture the error output
        ERROR_OUTPUT=$($AWS_CMD cloudformation $OPERATION \
            --stack-name "$STACK_NAME" \
            --template-body file://"$TEMPLATE_FILE" \
            --parameters file://"$PARAMETERS_FILE" \
            --capabilities CAPABILITY_NAMED_IAM \
            --tags Key=Environment,Value="$ENVIRONMENT" Key=Project,Value=example-service 2>&1)
        
        # Check if it's the "No updates" error
        if echo "$ERROR_OUTPUT" | grep -q "No updates are to be performed"; then
            print_success "Stack is already up to date. No changes detected."
            print_status "Current stack status:"
            show_stack_status
            return 0
        else
            print_error "Failed to initiate stack deployment:"
            echo "$ERROR_OUTPUT"
            exit 1
        fi
    fi
}

# Function to delete stack
delete_stack() {
    print_status "Deleting CloudFormation stack: $STACK_NAME"
    
    if ! stack_exists; then
        print_error "Stack '$STACK_NAME' does not exist"
        exit 1
    fi
    
    if $AWS_CMD cloudformation delete-stack --stack-name "$STACK_NAME"; then
        print_success "Stack deletion initiated"
        
        print_status "Waiting for stack deletion to complete..."
        $AWS_CMD cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"
        
        if [ $? -eq 0 ]; then
            print_success "Stack deleted successfully"
        else
            print_error "Stack deletion failed"
            exit 1
        fi
    else
        print_error "Failed to initiate stack deletion"
        exit 1
    fi
}

# Function to check stack status
show_stack_status() {
    if stack_exists; then
        print_status "Stack status:"
        $AWS_CMD cloudformation describe-stacks \
            --stack-name "$STACK_NAME" \
            --query 'Stacks[0].{Status:StackStatus,Description:Description,CreationTime:CreationTime,LastUpdatedTime:LastUpdatedTime}' \
            --output table
    else
        print_status "Stack '$STACK_NAME' does not exist"
    fi
}

# Main execution
echo -e "${BLUE}=== CloudFormation Deployment Script ===${NC}"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if AWS credentials are configured
if ! $AWS_CMD sts get-caller-identity >/dev/null 2>&1; then
    print_error "AWS credentials not configured. Please run 'aws configure' first."
    exit 1
fi

# Execute based on options
if [ "$VALIDATE_ONLY" = true ]; then
    validate_template
elif [ "$DELETE_STACK" = true ]; then
    delete_stack
else
    deploy_stack
    echo ""
    show_stack_status
fi

echo ""
print_success "Script completed successfully!" 