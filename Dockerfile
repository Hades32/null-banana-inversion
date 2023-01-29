# Must use a Cuda version 11+
FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime

WORKDIR /

# Install git
RUN apt-get update && apt-get install -y git

# Install python packages
RUN pip3 install --upgrade pip
RUN pip install --quiet diffusers==0.8.0
RUN pip install --quiet https://github.com/brian6091/xformers-wheels/releases/download/0.0.15.dev0%2B4c06c79/xformers-0.0.15.dev0+4c06c79.d20221205-cp38-cp38-linux_x86_64.whl
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
