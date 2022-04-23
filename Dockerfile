FROM elixir:alpine

RUN apk update && apk upgrade && \
  apk add postgresql-client && \
  apk add inotify-tools && \
  apk add build-base && \
  rm -rf /var/cache/apk/*

ENV MIX_ENV dev

RUN mix do local.hex --force, local.rebar --force

COPY mix.* ./

RUN mix do deps.get
RUN mix deps.compile

COPY assets/package.json assets/

COPY . ./

RUN mix do assets.deploy, compile, phx.digest



RUN chmod +x entrypoint.sh
CMD ["/entrypoint.sh"]

