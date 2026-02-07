**Objective:** Create a Docker file to run a python script, with pip dependencies

Dockerfile
```Dockerfile
FROM python:3.11.14-alpine3.23
WORKDIR /home
RUN pip install numpy
COPY app.py .
CMD ["python","./app.py"]
```


App.py
```Python
import numpy as np  

stored_sapid = "500119650"
while (True):
    user_sapid = input("Enter your SAP ID: ")
    if user_sapid == stored_sapid:
        print("Matched")
    else:
        print("Not Matched")
```

To build and run the Container
```Bash
docker build -t pythonappnosrc:1.0 -f nosrc.Dockerfile .
docker run -it pythonappnosrc:1.0
docker run -it -v ./:/home  pythonappnosrc:1.0 
```