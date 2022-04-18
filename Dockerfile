FROM golang:latest 
RUN mkdir /app
RUN chmod 777 /app
ADD . /app/ 
WORKDIR /app
RUN go get -d
RUN go build -o main . 
CMD ["/app/main"]
EXPOSE 80
