FROM mcr.microsoft.com/dotnet/aspnet:6.0
ENV DEBIAN_FRONTEND=noninteractive

# deb http://snapshot.debian.org/archive/debian/20230612T000000Z bullseye main
RUN echo "deb [trusted=yes] https://deb.debian.org/debian bullseye main" > /etc/apt/sources.list
# deb http://snapshot.debian.org/archive/debian-security/20230612T000000Z bullseye-security main
RUN echo "deb [trusted=yes] https://deb.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list
# deb http://snapshot.debian.org/archive/debian/20230612T000000Z bullseye-updates main
RUN echo "deb [trusted=yes] https://deb.debian.org/debian bullseye-updates main" >> /etc/apt/sources.list

RUN apt-get update -yq && apt-get install -y --no-install-recommends apt-utils
RUN apt-get upgrade -yq && apt-get install -yq apt-utils curl git nano wget unzip python3 python3-pip
RUN curl -sL https://deb.nodesource.com/setup_current.x | bash - && apt-get install -yq nodejs build-essential

RUN echo 'deb [trusted=yes] https://httpredir.debian.org/debian buster-backports main contrib non-free' | tee -a /etc/apt/sources.list.d/debian-backports.list
RUN apt install libseccomp2 
RUN apt-get clean && apt-get update

RUN apt-get install firefox-esr -y && firefox-esr --version 
RUN apt-get install chromium -y && chromium --version 

RUN pip3 install webdrivermanager || true 
RUN apt-get update && apt-get autoclean && apt-get autoremove -y

RUN webdrivermanager firefox chrome --linkpath /usr/local/bin || true
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN wget $(curl -s https://api.github.com/repos/openbullet/OpenBullet2/releases/latest | grep 'browser_' | cut -d\" -f4)
RUN unzip OpenBullet2.zip
RUN rm OpenBullet2.zip
EXPOSE 5000
CMD ["dotnet", "./OpenBullet2.dll", "--urls=http://*:5000"]
