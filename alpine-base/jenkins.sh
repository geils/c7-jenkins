#! /bin/bash -e

if [ -f /var/lib/jenkins/DOWNLOAD_HOME ]; then
    echo "HOMEFILE EXIST... WILL PASS DOWNLOAD JENKINS HOME"
else
    echo "HOMEFILE IS NOT EXIST. START DOWNLOAD JENKINS HOME"
    mkdir -p /tmp/jenkins_home
    git clone https://github.com/dostroke/jenkins_home.git /tmp/jenkins_home
    cp -R /tmp/jenkins_home/* /var/lib/jenkins/
    echo -e "DOWNLOADED at $(date +%Y-%m-%d)" > /var/lib/jenkins/DOWNLOAD_HOME
fi

: "${JENKINS_HOME:="/var/lib/jenkins"}"
touch "${COPY_REFERENCE_FILE_LOG}" || { echo "Can not write to ${COPY_REFERENCE_FILE_LOG}. Wrong volume permissions?"; exit 1; }
echo "--- Copying files at $(date)" >> "$COPY_REFERENCE_FILE_LOG"
find /usr/share/jenkins/ref/ -type f -exec bash -c '. /usr/local/bin/jenkins-support; for arg; do copy_reference_file "$arg"; done' _ {} +

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then

  # read JAVA_OPTS and JENKINS_OPTS into arrays to avoid need for eval (and associated vulnerabilities)
  java_opts_array=()
  while IFS= read -r -d '' item; do
    java_opts_array+=( "$item" )
  done < <([[ $JAVA_OPTS ]] && xargs printf '%s\0' <<<"$JAVA_OPTS")

  jenkins_opts_array=( )
  while IFS= read -r -d '' item; do
    jenkins_opts_array+=( "$item" )
  done < <([[ $JENKINS_OPTS ]] && xargs printf '%s\0' <<<"$JENKINS_OPTS")

  exec java "${java_opts_array[@]}" -jar /usr/share/jenkins/jenkins.war "${jenkins_opts_array[@]}" "$@"
fi
# As argument is not jenkins, assume user want to run his own process, for example a `bash` shell to explore this image
exec "$@"
