build-prod-app:
	docker buildx build -t idiom-app:latest .
build-tar:
	docker save -o idiomapp.tar idiom-app