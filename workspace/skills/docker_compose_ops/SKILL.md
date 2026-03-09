---
name: docker_compose_ops
description: Safely operate Docker and Docker Compose environments.
metadata:
  openclaw:
    requires:
      bins:
        - docker
        - docker
---
# Docker Compose Operations
Use this skill whenever interacting with Docker containers or Compose stacks.
Workflow:
1. Inspect running containers
docker ps
2. Inspect compose configuration
docker compose config
3. Check logs before taking action
docker logs --tail 100 <container>
4. Restart services if needed
docker compose restart <service>
5. Rebuild images when required
docker compose build
6. Recreate containers safely
docker compose up -d --force-recreate <service>
Rules:
- Never destroy containers or volumes unless explicitly instructed.
- Always inspect logs before assuming failure.
- Prefer restarting a single service rather than the entire stack.
- Avoid `docker system prune` unless explicitly requested.