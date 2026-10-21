FROM alpine:3.24

# Install necessary packages for building and running the project
RUN apk add --no-cache \
        bash \
        ca-certificates \
        coreutils \
        curl \
        git \
        nodejs \
        npm \
        openjdk25-jre-headless \
        unzip \
        libxslt

# Saxon and SchXslt
RUN curl --fail --location --output /tmp/saxon.zip \
        https://downloads.saxonica.com/SaxonJ/HE/13/SaxonHE13-0J.zip \
    && unzip /tmp/saxon.zip -d /opt/saxon \
    && rm /tmp/saxon.zip \
    && curl --fail --location --output /tmp/schxslt2.zip \
        https://codeberg.org/SchXslt/schxslt2/releases/download/v1.11.2/schxslt2-1.11.2.zip \
    && unzip /tmp/schxslt2.zip -d /opt/schxslt2 \
    && rm /tmp/schxslt2.zip

WORKDIR /workspace

# LDML.de repository
ARG LDML_DE_COMMIT=a654f19fa6182ec8dabbb9bcc0d826ab07ac54f9
RUN git init --quiet /tmp/ldml-de \
    && git -C /tmp/ldml-de remote add origin https://gitlab.opencode.de/bmi/e-gesetzgebung/ldml_de.git \
    && git -C /tmp/ldml-de sparse-checkout set Grammatiken \
    && git -C /tmp/ldml-de fetch --depth=1 origin "$LDML_DE_COMMIT" \
    && git -C /tmp/ldml-de checkout --detach FETCH_HEAD \
    && mkdir -p /opt/ldml-de \
    && mv /tmp/ldml-de/Grammatiken /opt/ldml-de/ \
    && rm -rf /tmp/ldml-de

# Prettier setup
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts
COPY prettier.config.ts .prettierignore ./

# LDML.de patches
COPY scripts/ldmlde-patches/*.xsl scripts/ldmlde-patches/
COPY scripts/norms-ldml-tool.sh scripts/norms-ldml-tool.sh

ENTRYPOINT ["bash", "/workspace/scripts/norms-ldml-tool.sh"]
