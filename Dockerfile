# Start with the official Ubuntu base image
FROM ubuntu:latest

# Set the working directory inside the container
WORKDIR /fastapp

# Copy the requirements.txt into the container's /fastapp directory
COPY requirements.txt /fastapp/requirements.txt

# Copy the app directory (including all its contents) into /fastapp/app in the container
COPY app /fastapp/app

# Install necessary dependencies (Python 3 and pip)
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install -r /fastapp/requirements.txt

# Set the ENTRYPOINT to use python3 as the executable
ENTRYPOINT ["python3"]

# Define the default command that will be executed (run the app's main.py)
CMD ["app/main.py", "runserver", "0.0.0.0:8000"]
