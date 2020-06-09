FROM golang:1.10
RUN go get github.com/mdlayher/apcupsd_exporter
RUN go build src/github.com/mdlayher/apcupsd_exporter/cmd/apcupsd_exporter/main.go
RUN chmod +x main
EXPOSE 9162

CMD ./main
