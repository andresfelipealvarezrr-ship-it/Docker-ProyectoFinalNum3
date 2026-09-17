up:
	docker compose up -d

down:
	docker compose down

down-v:
	docker compose down -v

logs:
	docker compose logs -f

ps:
	docker compose ps

test:
	curl -s http://localhost:4000/health
	curl -s http://localhost:4000/api/users
