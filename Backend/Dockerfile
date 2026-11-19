FROM swift:5.10-jammy AS build
WORKDIR /app
COPY Package.swift ./
COPY Sources ./Sources
RUN swift build -c release
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y libcurl4 libatomic1 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /app/.build/release/App /app/server
ENV HOST=0.0.0.0 PORT=8080
EXPOSE 8080
CMD ["/app/server"]
