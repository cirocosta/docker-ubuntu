image-zesty:
	cd ./zesty && \
		docker build -t cirocosta/ubuntu .

images: image-zesty

push-images:
	docker push cirocosta/ubuntu

test:
	bash ./test.sh

.PHONY: images test push-images
