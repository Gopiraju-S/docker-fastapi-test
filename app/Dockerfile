FROM ubuntu:latest

# Set the working directory in the image
WORKDIR /app

# Copy the files from the host file system to the image file system
COPY requirements.txt /app
COPY app /app

# Install the necessary packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip install -r requirements.txt && \
    cd data

# Set environment variables
ENTRYPOINT ["python3"]

# Run a command to start the application
CMD ["python3", "main.py","runserver", "0.0.0.0:8000"]
