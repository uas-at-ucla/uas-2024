APP_NAME=suas-vision
PORT=8003

build:
	docker compose build
	
run:
	docker compose up -d
	
restart:
	docker compose restart

kill:
	docker compose kill
	
test:
	docker compose build && docker compose up -d && \
		docker exec uas-2024-vision-1 python3 -m unittest
		
coverage:
	docker compose build && docker compose up -d && \
		docker exec uas-2024-vision-1 bash -c \
		"coverage run -m unittest; coverage xml -i"