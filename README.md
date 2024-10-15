# demo-unifi-2024-10-15
## Architecture
![alt text](assets/ddb-crud.png)

## Manual (bad way)
https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-dynamo-db.html

## IaC (right way)
### Login
export AWS_REGION=eu-central-1
export AWS_ACCESS_KEY_ID=***
export AWS_SECRET_ACCESS_KEY=***

### Terraform
terraform init
terraform apply --var-file=env/development.tfvars
terraform apply --var-file=env/production.tfvars

### Tests
curl https://o5spyqva1e.execute-api.eu-central-1.amazonaws.com/items

curl -X "PUT" -H "Content-Type: application/json" -d "{\"id\": \"123\", \"price\": 12345, \"name\": \"myitem\"}" https://o5spyqva1e.execute-api.eu-central-1.amazonaws.com/items

curl -X "PUT" -H "Content-Type: application/json" -d "{\"id\": \"123\", \"price\": 12345, \"name\": \"myitem\"}" https://2mtuinph5g.execute-api.eu-central-1.amazonaws.com/items

