JENKINS
=======

**DOWNLOAD ANDROID SDK**
```
wget https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
mkdir /app/android-tools
unzip -d /app/android-tools tools_r25.2.3-linux.zip
```

**INSTALL DEPENDENCY PACKAGES**
```
yum install zlib.i686 ncurses-libs.i686 bzip2-libs.i686
```

**INSTALL SDK**
```
cd /app/android-tools/tools
./android list sdk --all
./android update sdk -u -a -t 1,2,4,5,6,7,8,9,10,11,12,13,14,18,19,20,35,36,37,38,39,40,164
```

**GIVE PERMISSIONS**
```
chown -R jenkins:jenkins /app/android-tools
```

**TOUCH REPOSITORIES.CFG**
```
touch /app/android-tools/tools/.android/repositories.cfg
echo "### User Sources for Android SDK Manager" >> /app/android-tools/tools/.android/repositories.cfg
echo "count=0" >> /app/android-tools/tools/.android/repositories.cfg
```

**INSTALL SSL CERT FOR GOOGLE**
```
cp InstallCert.java /tmp
cd /tmp
javac InstallCert.java
java InstallCert google.com
cp -R jssecacerts /usr/java/jdk1.8.0_121/jre/lib/security
```


