.PHONY: build

IMAGE := suin/qiita-markdown-server

build:
	docker build -t $(IMAGE) .

demo:
	docker-compose up -d
	cat request-body-example.json | http -v POST qmd.docker/markdown
	docker-compose stop
