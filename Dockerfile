# 최신 CUDA 버전과 PyTorch를 포함한 기본 이미지를 사용
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

WORKDIR /omnimotion

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    git \
    wget \
    vim \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 추가적인 Python 패키지 설치 (필요에 따라 수정)
RUN pip install --upgrade pip
RUN pip install --upgrade typing_extensions
RUN pip install matplotlib tensorboard scipy opencv-python tqdm tensorboardX configargparse ipdb kornia imageio[ffmpeg]

