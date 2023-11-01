# Build stage
FROM golang:1.20-alpine as builder

COPY ./github.com/ksmkhnads/subscription-payment-reminder-bot /github.com/ksmkhnads/subscription-payment-reminder-bot/
WORKDIR /ksmkhnads/subscription-payment-reminder-bot/

# Copy only the necessary files for building
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of your application
COPY . .

# Build the Go application
RUN go build -o /go/bin/bot cmd/bot/main.go

# Final stage
FROM alpine:latest

WORKDIR /root/

# Copy the binary from the build stage
COPY --from=builder /go/bin/bot .

EXPOSE 80

# Specify the command to run your application
CMD ["./bot"]
