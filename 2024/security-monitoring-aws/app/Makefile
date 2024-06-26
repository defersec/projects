build: build-lambda

build-lambda:
	GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o ./build/lambda-function.bin lambda/main.go

build-docker:
	docker build --platform linux/amd64 -t security-monitoring-aws:latest .

run-local:
	docker run -d -p 9000:8080 --entrypoint /usr/local/bin/aws-lambda-rie security-monitoring-aws:latest /runtime/lambda-function.bin
