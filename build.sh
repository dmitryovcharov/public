docker build -t devops-task .
docker create --name devops-task devops-task
docker cp devops-task:/app/.open-next/ ./out
docker rm devops-task


docker tag devops-task:latest localhost:5001/devops-task:1.0
docker push localhost:5001/devops-task:1.0
