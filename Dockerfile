FROM sd2e/base:ubuntu17

ARG src_file=pwiz-bin-linux-x86_64-gcc48-release-3_0_20009_2d13cc1.tar.bz2
COPY src/$src_file /opt/$src_file

RUN cd /opt && \
    tar -xvjf $src_file ./msconvert && \
    rm $src_file 

ENV PATH "/opt:$PATH"

CMD ["msconvert", "--help"]

