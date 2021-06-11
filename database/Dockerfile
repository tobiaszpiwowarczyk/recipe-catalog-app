FROM postgres:latest

EXPOSE 5432

VOLUME ["/docker-entrypoint-initdb.d"]

COPY src/schema.sql /docker-entrypoint-initdb.d/