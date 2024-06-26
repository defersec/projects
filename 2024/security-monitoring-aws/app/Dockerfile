# Specify the same version you used to build the Golang binary
FROM golang:1.22 as build
WORKDIR /runtime

# Use AWS OS image
FROM public.ecr.aws/lambda/provided:al2023

# Copy artifacts
COPY ./build/lambda-function.bin /runtime/lambda-function.bin

# Specify entrypoint
ENTRYPOINT [ "/runtime/lambda-function.bin" ]
