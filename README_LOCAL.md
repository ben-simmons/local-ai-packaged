# Local Setup

Running on mac with a separate ollama instance outside of docker.


## Settings

`.env`:

```
############
# N8N Configuration
############
N8N_ENCRYPTION_KEY=
N8N_USER_MANAGEMENT_JWT_SECRET=

############
# Supabase Secrets
############
POSTGRES_PASSWORD=
JWT_SECRET=
ANON_KEY=
SERVICE_ROLE_KEY=
DASHBOARD_USERNAME=
DASHBOARD_PASSWORD=

############
# Supavisor -- Database pooler
############
POOLER_TENANT_ID=
```

`docker-compose.yml`:

```
x-n8n: &service-n8n
  # ... other configurations ...
  environment:
    # ... other environment variables ...
    - OLLAMA_HOST=host.docker.internal:11434
```


## Start

Run ollama locally:

```
ollama serve
```

Start docker stack:

```
cd /PATH/TO/local-ai-packaged
python start_services.py --profile none
```


## n8n

Shared directory with filesystem is `/PATH/TO/local-ai-packaged/shared`.

Export workflows to repo:




## Testing

### Add local file to knowledgebase

Move a file to `/PATH/TO/local-ai-packaged/shared`.

The n8n local file trigger is mapped to `/data/shared`, which is mounted for the `shared` directory in this project.


## Upgrading

To upgrade docker containers:

```
# Stop all services
docker compose -p localai -f docker-compose.yml -f supabase/docker/docker-compose.yml down

# Pull latest versions of all containers
docker compose -p localai -f docker-compose.yml -f supabase/docker/docker-compose.yml pull

# Start services again with your desired profile
python start_services.py --profile none
```

To pull latest code from the original local-ai-packaged repo:

1. Add the upstream remote:
  * `git remote add upstream https://github.com/coleam00/local-ai-packaged.git`
2. Merge upstream changes into main and then merge main into my local branch:
  * `git fetch upstream && git checkout main && git merge upstream/main && git checkout local && git merge main`

See [Configuring Git to sync your fork with the upstream repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#configuring-git-to-sync-your-fork-with-the-upstream-repository)


## Teardown

Delete all containers and their volumes:

`docker compose -p localai -f docker-compose.yml -f supabase/docker/docker-compose.yml down -v --remove-orphans`

Delete the `shared` folder (mounted to n8n):

`rm -rf /PATH/TO/local-ai-packaged/shared`

Delete the `supabase` folder (cloned in by `start_services.py`):

`rm -rf /PATH/TO/local-ai-packaged/supabase`


## Troubleshooting

### Supabase Analytics Startup Failure

If the supabase-analytics container fails to start after changing your Postgres password, delete the folder `supabase/docker/volumes/db/data`.

Note that the `supabase` directory is not checked into git; it's created as part of `start_service.py`, and it's in `.gitignore`, so you may have to delete it from your filesystem instead of through an IDE.

### Find docker config

Equivalent to searching through the Inspect tab of every running container via Docker Desktop:

`docker compose -p localai ps -q | xargs -I {} docker inspect {} | grep -i "service_role"`
