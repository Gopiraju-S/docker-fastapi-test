# Docker-Fastapi-Test
## Overview

We have a simple FastAPI application that needs to be dockerized. This can be done by using the Docker. For aplication files like code and requrirements are stored in a Github. 
Repository: https://github.com/RohitPatil18/docker-fastapi-test 

We should be able to run an application using a docker-compose file. Please note that we are not using a database instead storing data in a users.json file in the data directory which will get automatically created if not present. 


Once the application runs successfully, make sure to destroy containers and recreate another one and check if previous data is still present.

## Step-By-Step Implementation
### 1. Setting Up the AWS amazon-linux2 Instance:
##### A.  Launch an EC2 Instance:
   1. Go to the AWS Management Console and navigate to EC2.
   2. Click "Launch Instance" and select an Amazon-linux2 AMI.
   3. Choose an instance type (e.g., t2. micro for free tier eligibility).

 ![Untitled](Images/instance1.png)

   4. Configure instance details, add storage, and add tags if necessary.
   5. Configure security group to allow HTTP (port 80), HTTPS (port 443), and SSH (port 22) access.
   6. Review and launch the instance.
      
![Untitled](Images/instance2.png)
         
##### Connect to the EC2 instance:
Use SSH to connect to your instance.
     ssh -i your-key-pair.pem ec2-user@your-instance-public-ip


### 2.  Install Docker On Linux:
##### A. Update the package index:
     sudo yum update
     sudo yum install -y docker

Now, run docker command:

     docker --version
  
     docker run hello-workld
     
When we run above command, Docker deamon creates a sample hello world container. 
but, Output we axcpected as **permission denaied**: 

 ![Untitled](Images/1.png)

##### C. Start and enable Docker service:

        #check for docker status
        systemctl status docker

 ![Untitled](Images/2.png)
 
    sudo systemctl start docker
    sudo systemctl enable docker
    systemctl status docker
    
 ![Untitled](Images/3.png)
 
##### B. Provide a Docker privilidges 
 So this we need to provide the admin priviledges to run the docker commands.
      # Create the docker group
      sudo groupadd docker

      # Add the ec2-user to docker
      sudo usermod -aG docker ec2-user
     
Again do sample docker run command:

       docker run hello-world
       #output: ----
          # Hello from Docker!
          # This message shows that your installation appears to be working correctly.
           -----

![Untitled](Images/88.png)
### 3. install Git on an Amazon-linux2 system, follow these steps:
Update the Package Index
1. First, ensure your package index is up-to-date:
   
       sudo apt update

3. Install Git
Install Git using the package manager:

       sudo apt install git -y
   
4. Verify the Installation
Check the installed version of Git to verify the installation:

       git --version

Now, do the clone as mentioned abelow steps.

3. Prepare the FastApi Application:
   
Clone the Repository:

       git clone https://github.com/Gopiraju-S/docker-fastapi-test.git

Change the directory to the fastapi applicaton:

       cd docker-fastapi-test

![Untitled](Images/4.png)

### 4. Login to Docker [Create an account with https://hub.docker.com/]
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
      docker login
      
      Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
      Username: gopiraju06
      Password:
      WARNING! Your password will be stored unencrypted in /home/ubuntu/.docker/config.json.
      Configure a credential helper to remove this warning. See
      https://docs.docker.com/engine/reference/commandline/login/#credentials-store

      Login Succeeded

![Untitled](Images/5.png)

### 5. Create the DOckerfile.yml

Here, Dockerfile already created in my Github repocitory:
And we can create the new Dockerfile in a aplication level folder.

    sudo nano Dockerfile

Enter the docker text.

    # Use Ubuntu as the base image
    FROM ubuntu:20.04

    # Set environment variables to prevent interactive prompts during apt-get installation
    ENV DEBIAN_FRONTEND=noninteractive

    # Update the package list and install dependencies (Python, pip, etc.)
    RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-dev build-essential && \
    apt-get clean

    # Set the working directory inside the container
    WORKDIR /app

    # Copy the requirements.txt to the working directory
    COPY requirements.txt .

    # Install the Python dependencies from requirements.txt
    RUN pip3 install --no-cache-dir -r requirements.txt

    # Copy the FastAPI application code to the container
    COPY . .

    # Expose the port that FastAPI will run on
    EXPOSE 8000

    # Set the default command to run the FastAPI app with Uvicorn
    CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]



### 5. Create Docker FastApi Aplication Image:

Check for existed list of images:

     docker images

Command to Create the Docker Image:

     docker build -t Gopiraju-S/fast-api-image .

     docker images
 
![Untitled](Images/6.png)

Command to create the Docker Container:

     docker run -itd -p 8000:8000 --name first-container --mount type=bind,source=/varlib/docker/volumes/api_data,target=/app/app/data Gopiraju-S/fast-api-image
     

![Untitled](Images/8.png)  

Command to Get the data from first-Container server

     # It  shows 'Hello from Fastapi'
     curl http://localhost:8000

     # It shows empty data []
     curl http://localhost:8000/users

Console Output:

![Untitled](Images/9.png)

Web-server output:
![Untitled](Images/9.1.png)

![Untitled](Images/9.2.png)

Post the data to first-container server by using the **curl**:

     # first record 
     curl -X POST -H "COntent-Type: application/json" -d '{"first_name": "Gopiraju", "last_name": "Sankurathri", "age": 23}' http://localhost:8000/users

     # Secon record
     curl -X POST -H "COntent-Type: application/json" -d '{"first_name": "Ravi", "last_name": "Tota", "age": 23}' http://localhost:8000/users

![Untitled](Images/10.png)

Check the data stored in a first-container Server:

Command to Get the data from first-Container server

     # It  shows 'Hello from Fastapi'
     curl http://localhost:8000

     # It shows data stored in a /users.json
     curl http://localhost:8000/users

     # Search in a Web-Server

     http://public_ip:8000
     http://public_ip:8000/users


![Untitled](Images/11.png)

Destroying the first-container:

     # stop the container
     docker stop first-container

     # Delete the container 
     docker rm first-container
     
![Untitled](Images/12.png)

Once the application runs successfully, make sure to destroy containers and recreate another one and check if previous data is still present.

Command to create the Docker sencond-Container shows in below image:

     docker run -itd -p 8000:8000 --name second-container --mount type=bind,source=/varlib/docker/volumes/api_data,target=/app/app/data Gopiraju-S/fast-api-image
     
![Untitled](Images/18.png)

check if previous data is still present.

Command to Get the data from second-Container server

     # It  shows 'Hello from Fastapi'
     curl http://localhost:8000

     # It shows data stored in a /users.json
     curl http://localhost:8000/users

     # Search in a Web-Server
     
     http://public_ip:8000
     http://public_ip:8000/users

![Untitled](Images/13.png)
     
![Untitled](Images/11.png)



