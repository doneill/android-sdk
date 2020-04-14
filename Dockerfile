FROM openjdk:8

ENV ANDROID_HOME="/opt/android-sdk-linux"
ENV ANDROID_VERSION=29
ENV ANDROID_BUILD_TOOLS_VERSION=29.0.2

# Download Android SDK into $ANDROID_HOME
# You can find URL to the current version at: https://developer.android.com/studio/index.html
RUN mkdir -p ${ANDROID_HOME} && \
    cd ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O android_tools.zip && \
    unzip android_tools.zip && \
    rm android_tools.zip

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Accept Android SDK licenses
RUN yes | sdkmanager --licenses

# To get a full list of available options you can use:
#  sdkmanager --list --verbose
RUN sdkmanager "platform-tools"
RUN sdkmanager "platforms;android-${ANDROID_VERSION}"
RUN sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"
RUN sdkmanager "extras;google;m2repository"
RUN sdkmanager "extras;android;m2repository"
RUN sdkmanager "extras;google;google_play_services"

RUN mkdir /apps
WORKDIR /apps