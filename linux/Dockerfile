FROM ubuntu:18.04

RUN apt update && apt install -y gnupg gnupg2 gnupg1 && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu nightly-bionic main" | tee /etc/apt/sources.list.d/mono-official-nightly.list && \
    echo "deb https://download.mono-project.com/repo/ubuntu preview-bionic main" | tee /etc/apt/sources.list.d/mono-official-preview.list && \
    apt update && apt install -y mono-devel mono-complete referenceassemblies-pcl ca-certificates-mono mono-xsp4 openjdk-11-jdk-headless vim build-essential

ADD nant-0.92-bin.tar.gz /usr/local/

COPY nant /usr/local/bin/nant
COPY NAnt.exe.config /usr/local/nant-0.92/bin/NAnt.exe.config

RUN chmod a+x /usr/local/bin/nant

CMD /usr/local/bin/nant