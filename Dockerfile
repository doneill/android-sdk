# ====================================================================== #
# Android SDK Docker Image
# ====================================================================== #

FROM openjdk:11

# Author
# ---------------------------------------------------------------------- #
LABEL maintainer "dev@jdoneill.com"

ENV ANDROID_HOME="/opt/android-sdk"
ENV ANDROID_VERSION=29
ENV ANDROID_BUILD_TOOLS_VERSION=29.0.2
ENV KOTLIN_HOME /opt/kotlinc
ENV _JAVA_OPTIONS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap

# download and install Kotlin compiler
# https://github.com/JetBrains/kotlin/releases/latest
ARG KOTLIN_VERSION=1.4.32
RUN cd /opt && \
    wget -q https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip && \
    unzip *kotlin*.zip && \
    rm *kotlin*.zip

# Download Android SDK into $ANDROID_HOME
# You can find URL to the current version at: https://developer.android.com/studio#command-tools
ARG ANDROID_SDK_VERSION=4333796
RUN mkdir -p ${ANDROID_HOME} && \
    cd ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip -O android_tools.zip && \
    unzip android_tools.zip && \
    rm android_tools.zip

ENV PATH ${PATH}:${KOTLIN_HOME}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

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