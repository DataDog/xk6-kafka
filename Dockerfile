FROM golang:1.21 AS build

RUN go install go.k6.io/xk6/cmd/xk6@latest
COPY . /k6-kafka
WORKDIR /k6-kafka
RUN xk6 build --output /k6-kafka/xk6-kafka --with github.com/mostafa/xk6-kafka@main

FROM alpine

RUN apk add --no-cache ca-certificates && \
    adduser -D -u 12345 -g 12345 k6

COPY --from=build /k6-kafka/xk6-kafka /usr/bin/k6

USER 12345
WORKDIR /home/k6
ENTRYPOINT ["k6"]
