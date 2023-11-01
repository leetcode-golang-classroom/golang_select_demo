.PHONY=build_select_sample

build_select_sample:
	@go build -o bin/main select_sample/main.go

run_select_sample: build_select_sample
	@./bin/main

build_parallel_get:
	@go build -o bin/main parallel_get/main.go
run_parallel_get: build_parallel_get
	@./bin/main

build_ticker_sample:
	@go build -o bin/main ticker_sample/main.go
run_ticker_sample: build_ticker_sample
	@./bin/main
# test:
# 	@go test -v ./...