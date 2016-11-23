FROM alpine:3.4

ENV JEKYLL_DIR=/opt/jekyll
ENV BLOG_DIR=${JEKYLL_DIR}/blog

RUN apk --no-cache add ruby \
                       ruby-bundler \
                       ruby-dev \
                       libffi \
                       libffi-dev \
                       ruby-rdoc \
                       ruby-irb \
                       g++ \
                       make \
                       ca-certificates \
                       nginx && \
    gem install --source http://rubygems.org jekyll bundler && \
    mkdir -p ${JEKYLL_DIR} && \
    mkdir -p /run/nginx

ADD nginx.conf ${JEKYLL_DIR}/nginx.conf
ADD blog ${BLOG_DIR}
RUN cd ${BLOG_DIR} && \
        bundle install && \
        bundle exec jekyll build

RUN apk del ruby \
            ruby-bundler \
            ruby-dev \
            libffi \
            libffi-dev \
            ruby-rdoc \
            ruby-irb \
            g++ \
            make

EXPOSE 80

CMD ["nginx", "-c", "/opt/jekyll/nginx.conf"]
