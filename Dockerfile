# Stage I: Development Image ==========================================================================================================

FROM openjdk:14-jdk-alphine AS development

#2 Definir directorio de trabajo
WORKDIR /usr/src

#3 vARIABLES DE ENTORNO
ENV HOME=/usr/src

#Definir las versiones de gradle a descargar
ENV GRADLE_VERSION=6.3 GRADLE_USER_HOME=/usr/local/gradle

#Add Gradle executable s to PATH:
ENV PATH=/opt/gradle/gradle-${GRADLE_VERSION}/bin:${PATH}


# Step 7: Install the configured Gradle version:
RUN curl -L -o "gradle-${GRADLE_VERSION}-bin.zip" \
  "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
 && mkdir -p /opt/gradle /usr/local/gradle \
 && unzip -d /opt/gradle gradle-${GRADLE_VERSION}-bin.zip \
 && rm -rf "gradle-${GRADLE_VERSION}-bin.zip"


 #step  Define default command:
 CMD ["gradle", "bootRun"]

# STAGE TESTING ==========================================================================================================

FROM development AS testing

COPY . /usr/src

CMD ["gradle", "test"]

# STAGE ==========================================================================================================

FROM testing AS builder

RUN gradle build -x test

# Release
FROM openjdk:14-jdk-alphine AS release

COPY --from=builder /usr/src/build/libs/demo-0.1-SNAPSHOT.jar .

# Set the default command


