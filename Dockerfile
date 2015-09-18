# Generic Hippo Docker image
FROM ubuntu:14.04
MAINTAINER Brian Snijders <brian@finalist.nl>

# Set environment variables
ENV \
  PATH="/srv/hippo/bin:$PATH" \
  HIPPO_PATH="/srv/hippo" \
  HIPPO_FILE="HippoCMS-GoGreen-Enterprise-7.9.4.zip" \
  HIPPO_FOLDER="HippoCMS-GoGreen-Enterprise-7.9.4" \
  HIPPO_URL="http://download.demo.onehippo.com/7.9.4/HippoCMS-GoGreen-Enterprise-7.9.4.zip" \
  DEBIAN_FRONTEND=noninteractive

# Create the work directory for Hippo
RUN \
  mkdir -p $HIPPO_PATH && \

  `# Add Oracle Java Repositories` \
  apt-get install -y curl unzip software-properties-common && \
  add-apt-repository ppa:webupd8team/java && \
  apt-get update && \

  `# Approve license conditions for headless operation` \
  echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections && \

  `# Install packages required to install Hippo CMS ` \
  apt-get install -y oracle-java7-installer oracle-java7-set-default dos2unix && \

  `# Install Hippo CMS, retrieving the GoGreen demonstration from the HIPPO_URL and putting it under HIPPO_FOLDER` \
  curl -L $HIPPO_URL -o $HIPPO_FILE && \
  unzip $HIPPO_FILE && \
  mv /$HIPPO_FOLDER/tomcat/* $HIPPO_PATH && \
  chmod -R 700 $HIPPO_PATH && \

  `# Replace DOS line breaks on Apache Tomcat scripts, to properly load JAVA_OPTS` \
  dos2unix $HIPPO_PATH/bin/setenv.sh && \
  dos2unix $HIPPO_PATH/bin/catalina.sh

# Expose ports
EXPOSE 8080

# Start Hippo
WORKDIR $HIPPO_PATH
CMD ["catalina.sh", "run"]
