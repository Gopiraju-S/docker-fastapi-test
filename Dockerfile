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
