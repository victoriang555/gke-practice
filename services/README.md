Things to note in monolith.yaml:

1. we've got a selector which is used to automatically find and expose any pods with the labels "app=monolith" and "secure=enabled"

2. Now I have to expose the nodeport here because this is how we'll forward external traffic from port 31000 to nginx (on port 443).