FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

# ultralytics dockerfile
RUN pip install --no-cache nvidia-tensorrt --index-url https://pypi.ngc.nvidia.com
ADD https://github.com/ultralytics/assets/releases/download/v0.0.0/Arial.ttf \
    https://github.com/ultralytics/assets/releases/download/v0.0.0/Arial.Unicode.ttf \
    /root/.config/Ultralytics/
RUN apt update \
    && apt install --no-install-recommends -y gcc git zip curl htop libgl1 libglib2.0-0 libpython3-dev gnupg g++ libusb-1.0-0
RUN apt upgrade --no-install-recommends -y openssl tar
WORKDIR /usr/src/ultralytics
RUN git clone https://github.com/ultralytics/ultralytics -b main /usr/src/ultralytics
ADD https://github.com/ultralytics/assets/releases/download/v8.1.0/yolov8n.pt /usr/src/ultralytics/
RUN python3 -m pip install --upgrade pip wheel
RUN pip install --no-cache -e ".[export]" albumentations comet pycocotools
RUN yolo export model=tmp/yolov8n.pt format=edgetpu imgsz=32 || yolo export model=tmp/yolov8n.pt format=edgetpu imgsz=32
RUN yolo export model=tmp/yolov8n.pt format=ncnn imgsz=32
RUN pip install --no-cache paddlepaddle>=2.6.0 x2paddle
RUN pip install --no-cache numpy==1.23.5
RUN rm -rf tmp
ENV OMP_NUM_THREADS=1
ENV MKL_THREADING_LAYER=GNU

# install libraries
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install ffmpeg libsm6 libxext6 -y
COPY vision/requirements.txt /vision/
RUN pip3 install -r /vision/requirements.txt

COPY . /app
WORKDIR /app
CMD ["bash","./vision/start_gunicorn.sh"]
