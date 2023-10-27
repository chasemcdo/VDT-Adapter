FROM continuumio/anaconda3

ENV DATA data

RUN apt update
RUN apt install -y git

# RUN git clone https://github.com/mayug/VDT-Adapter.git
RUN git clone https://github.com/KaiyangZhou/Dassl.pytorch.git

WORKDIR /Dassl.pytorch
RUN conda install pytorch torchvision cudatoolkit -c pytorch -c conda-forge
RUN pip install -r requirements.txt
RUN python setup.py develop

# Caltech101 - https://drive.google.com/file/d/137RyRjvTBkBiIfeYBNZBtViDHQ6_Ewsp/view?usp=share_link
WORKDIR /FEAT/data/caltech-101
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=137RyRjvTBkBiIfeYBNZBtViDHQ6_Ewsp' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=137RyRjvTBkBiIfeYBNZBtViDHQ6_Ewsp" -O 101_ObjectCategories.tar.gz && rm -rf /tmp/cookies.txt
RUN tar -xf 101_ObjectCategories.tar.gz && rm 101_ObjectCategories.tar.gz

RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1hyarUivQE36mY6jSomru6Fjd-JzwcCzN' -O split_zhou_Caltech101.json

COPY . /VDT-Adapter
WORKDIR /VDT-Adapter

# # RUN bash scripts/clip/main_gpt.sh caltech-101 vit_b16_c16_ep10_batch1 all zs_gpt_v
CMD [ "bash", "scripts/clip/main_gpt.sh", "caltech-101", "vit_b16_c16_ep10_batch1", "all", "zs_gpt_v" ]
