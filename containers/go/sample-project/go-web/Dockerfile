FROM cleanstart/go:latest-dev

RUN apk add --no-cache git ca-certificates wget

WORKDIR /app

COPY go.mod ./
COPY go.su[m] ./

COPY . .

RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -o go-web-app main.go

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

ENTRYPOINT ["./go-web-app"]