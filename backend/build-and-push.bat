@echo off
set AWS_REGION=ap-northeast-2
set AWS_ACCOUNT_ID=857360183365
set TAG=ojg

echo Logging into ECR...
aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com
if %ERRORLEVEL% neq 0 (
    echo ECR login failed.
    exit /b %ERRORLEVEL%
)

echo Building and pushing api-gateway...
docker build -t %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/api-gateway:%TAG% ./api-gateway
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/api-gateway:%TAG%

echo Building and pushing config-server...
docker build -t %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/config-server:%TAG% ./config-server
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/config-server:%TAG%

echo Building and pushing eureka-server...
docker build -t %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/eureka-server:%TAG% ./eureka-server
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/eureka-server:%TAG%

echo Building and pushing notification-service...
docker build -t %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/notification-service:%TAG% ./notification-service
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/notification-service:%TAG%

echo Building and pushing order-service...
docker build -t %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/order-service:%TAG% ./order-service
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/order-service:%TAG%

echo Building and pushing payment-service...
docker build -t %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/payment-service:%TAG% ./payment-service
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/payment-service:%TAG%

echo Building and pushing product-service...
docker build -t %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/product-service:%TAG% ./product-service
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/product-service:%TAG%

echo Building and pushing user-service...
docker build -t %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/user-service:%TAG% ./user-service
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/user-service:%TAG%

echo All builds and pushes completed successfully!
pause
