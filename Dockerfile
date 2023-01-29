# Must use a Cuda version 11+
#FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime
FROM gadicc/diffusers-api-base:python3.9-pytorch1.12.1-cuda11.6-xformers

WORKDIR /

# Install git
RUN apt-get update && apt-get install -y git

# Install python packages
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# We add the banana boilerplate here
COPY server.py .
EXPOSE 8000

# Add your huggingface auth key here
ARG HF_AUTH_TOKEN
ENV HF_AUTH_TOKEN=${HF_AUTH_TOKEN}

# Add your model weight files 
# (in this case we have a python script)
COPY download.py .
RUN python3 download.py

# Add your custom app code, init() and inference()
COPY *.py .

CMD python3 -u server.py
