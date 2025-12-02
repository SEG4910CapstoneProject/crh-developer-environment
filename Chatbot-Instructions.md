# Chatbot Instructions

The chatbot uses ollama and runs on port 11434. The model that is currently being used locally is llama3.2:3b. This could be changed, depending on computing power. 

## How to run the model
1. Run docker compose to set up all the containers. A new container for ollama should be created. For this step, use the command that you usually use to set up the containers. For example, docker compose --env-file ./local-variables.env up --no-start --detach. This could take up to 5 minutes, depending on local conditions such as internet connection. 

2. Start the Ollama container. This could be done using the 'Play' button on docker desktop or using docker commands.

3. Once the Ollama container is running, on the docker terminal run:
 **docker exec -it ollama ollama pull llama3.2:3b**
 **docker exec -it ollama ollama pull nomic-embed-text**

 This could take up to 5 minutes.

After completing these steps, the model will be available for queries. The container can be stopped or started like other containers using commands or docker desktop. 