image-zesty:
	cd ./zesty && \
		docker build -t cirocosta/ubuntu .

images: image-zesty

test:
	bash ./test.sh

.PHONY: images test
