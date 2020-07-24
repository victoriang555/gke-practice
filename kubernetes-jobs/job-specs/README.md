### Components of a job spec
1. Api version
2. Kind
3. Metadata
4. .spec section
5. Its name must be a valid DNS subdomain name
6. The .spec.template is the only required field of the .spec. the .spec.template is a pod template. It has exactly the same schema as a pod, except it is nested and does not have an apiVersion or kind. In addition to required fields for a Pod, a pod template in a Job must specify appropriate labels (see pod selector) and an appropriate restart policy. Only a RestartPolicy equal to Never or OnFailure is allowed.
7. The .spec.selector field is optional. In almost all cases you should not specify it.

Example job spec
```
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
  backoffLimit: 4
  ```