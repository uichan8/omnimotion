# omnimotion

## 환경설정
### 코드 다운로드
```bash
git clone --recurse-submodules https://github.com/uichan8/omnimotion.git #https 사용 (권장)
git clone --recurse-submodules git@github.com:uichan8/omnimotion.git #ssh 사용
```
### conda

### docker

## Train
### Data Preparation
#### 1. 비디오 이미지로 바꾸기
- 먼저 비디오를 이미지로 분리해서 저장해야 합니다. 다음과 같은 구조를 가지고 있어야 합니다.
```
├──sequence_name/
    ├──color/
        ├──00000.jpg
        ├──00001.jpg
        .....
```
- 비디오가 있을 때 명령어는 다음과 같습니다.
```bash
mkdir -p sequence_name/color
ffmpeg -i example.mp4 -vf scale=1280:720 sequence_name/color/%05d.jpg #720p
ffmpeg -i example.mp4 -vf scale=640:480 sequence_name/color/%05d.jpg #480p
```

#### 2. RAFT 설치
- RAFT를 설치하는 코드는 다음과 같습니다. 이 코드는 설치하는 과정이기떄문에 한번만 실행합니다.
```bash
cd preprocessing/  
cp exhaustive_raft.py filter_raft.py chain_raft.py RAFT/;
cd RAFT; ./download_models.sh; cd ../
cp extract_dino_features.py dino/
cd ../
```

#### 3. RAFT로 Optical flow 구하기
  - optical flow를 구하는 코드는 다음과 같습니다.
```bash
python main_processing.py --data_dir <sequence directory> --chain
```
- 위 코드를 실행하면 다음과 같은 폴더 구조를 가지게 됩니다.
```
├──sequence_name/
    ├──color/
    ├──mask/ (optional; only used for visualization purposes)
    ├──count_maps/
    ├──features/
    ├──raft_exhaustive/
    ├──raft_masks/
    ├──flow_stats.json
```

#### 5. Data Download
- 만약 그냥 처리된 데이터를 다운로드 받고 싶으면 다음 링크에서 데이터를 다운 받을 수 있습니다.  
[https://omnimotion.cs.cornell.edu/dataset/](https://omnimotion.cs.cornell.edu/dataset/)


### Train Data
- 다음 코드를 실행합니다.
```bash
python train.py --config configs/default.txt --data_dir {sequence_directory}
```
- 100k iterations 돌리는데 A100에서 9시간, 4090 13시간 정도 걸립니다.
- cuda memory를 22GB를 쓰는데, 이를 줄이고 싶을 경우 num_pts, chunk_size를 줄여야 합니다.

## forward(visulizaion)
- visualize 하는 명령어는 다음과 같습니다.
```bash
python viz.py --config configs/default.txt --data_dir {sequence_directory}
```
- 만약 train하지 않고 forward만 돌려보고 싶을 경우 다음 링크에서 데이터를 다운 받을 수 있습니다.  
[https://drive.google.com/drive/folders/16ekLy-4LTkYAavYrWaKk2qUpJ9TyMXlO](https://drive.google.com/drive/folders/16ekLy-4LTkYAavYrWaKk2qUpJ9TyMXlO)