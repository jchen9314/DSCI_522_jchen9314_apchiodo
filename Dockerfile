# Docker file for DSCI_522_jchen9314_apchiodo
# 
# Jingyun Chen, Anthony Chiodo -- Dec 6, 2018
#
# Description: This Dockerfile builds a Docker iamge of our project


# use rocker/tidyverse as the base image
FROM rocker/tidyverse

# install R packages used in this project
RUN Rscript -e "install.packages('rmarkdown')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('dplyr')"
RUN Rscript -e "install.packages('readr')"
RUN Rscript -e "install.packages('stringr')"
RUN Rscript -e "install.packages('gridExtra')"

# install Python 3
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

# get Python package dependencies
RUN apt-get install -y python3-tk

# install Python packages used in this project
RUN pip3 install numpy
RUN pip3 install pandas
RUN pip3 install scikit-learn
RUN apt-get install -y graphviz && pip install graphviz
RUN apt-get update && \
    pip3 install matplotlib && \
    rm -rf /var/lib/apt/lists/*
