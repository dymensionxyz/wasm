# Celestia Light Node
Build and run celestia light client
```sh
# inside the project folder:
docker build -t celestia-light-node celestia-light-node/.
docker run -d --rm -p 26658:26658 -p 9090:9090 --name celestia-light-node celestia-light-node
```
