# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - PostgreSQL container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart PostgreSQL image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/postgres:latest
```
```bash
docker pull cleanstart/postgres:latest-dev
```

## If you have the PostgreSQL image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app cleanstart/postgres:latest psql -f /app/hello_world.sql
```
## Output 
```bash
CREATE DATABASE
You are now connected to database "hello_world_db" as user "postgres".
CREATE TABLE
INSERT 0 1
INSERT 0 1
INSERT 0 1
 id |     name     |        message        
----+--------------+-----------------------
  1 | Hello World  | Welcome to PostgreSQL!
  2 | Database     | PostgreSQL is awesome!
  3 | CleanStart   | CleanStart + PostgreSQL = Perfect!
(3 rows)
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).