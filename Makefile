include env/postgres.env
include env/createdb.env

postgres:
	docker run --name postgres16 --env-file env/postgres.env -p 5432:5432 -v pgdata:/var/lib/postgresql/data -d --rm postgres:16.1-alpine

droppostgres:
	docker stop postgres16

createdb:
	docker exec -it postgres16 createdb --username=$(POSTGRES_USER) --owner=$(POSTGRES_USER) $(POSTGRES_DB)

dropdb:
	docker exec -it postgres16 dropdb --username=$(POSTGRES_USER) --if-exists --force $(POSTGRES_DB)

migrateup:
	migrate -path db/migrations -database "postgresql://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@localhost:5432/$(POSTGRES_DB)?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migrations -database "postgresql://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@localhost:5432/$(POSTGRES_DB)?sslmode=disable" -verbose down

.PHONY: postgres postgresdrop createdb dropdb migrateup migratedown
