# -----------------------------
# Configuration
# -----------------------------

COMPOSE_FILE_CV = docker/compose/cv.yml
SERVICE_CV      = cv
COMPOSE_FILE_AI = docker/compose/ai.yml
SERVICE_AI      = ai


# -----------------------------
# Docker lifecycle
# -----------------------------

.PHONY: cv-build
cv-build:
	docker compose -f $(COMPOSE_FILE_CV) build

.PHONY: ai-build
ai-build:
	docker compose -f $(COMPOSE_FILE_AI) build

.PHONY: cv-up
cv-up:
	docker compose -f $(COMPOSE_FILE_CV) up -d

.PHONY: ai-up
ai-up:
	docker compose -f $(COMPOSE_FILE_AI) up -d

.PHONY: cv-down
cv-down:
	docker compose -f $(COMPOSE_FILE_CV) down

.PHONY: ai-down
ai-down:
	docker compose -f $(COMPOSE_FILE_AI) down

.PHONY: cv-rebuild
cv-rebuild:
	docker compose -f $(COMPOSE_FILE_CV) build --no-cache
	docker compose -f $(COMPOSE_FILE_CV) up -d

.PHONY: ai-rebuild
ai-rebuild:
	docker compose -f $(COMPOSE_FILE_AI) build --no-cache
	docker compose -f $(COMPOSE_FILE_AI) up -d

# -----------------------------
# Interaction
# -----------------------------

.PHONY: cv-shell
cv-shell:
	xhost + && docker compose -f $(COMPOSE_FILE_CV) exec $(SERVICE_CV) bash && xhost -

.PHONY: ai-shell
ai-shell:
	xhost + && docker compose -f $(COMPOSE_FILE_AI) exec $(SERVICE_AI) bash && xhost -

.PHONY: cv-python
cv-python:
	docker compose -f $(COMPOSE_FILE_CV) exec $(SERVICE_CV) python

.PHONY: ai-python
ai-python:
	docker compose -f $(COMPOSE_FILE_AI) exec $(SERVICE_AI) python

.PHONY: cv-run-test
cv-run-test:
	docker compose -f $(COMPOSE_FILE_CV) exec $(SERVICE_CV) python source/test.py

.PHONY: ai-run-test
ai-run-test:
	docker compose -f $(COMPOSE_FILE_AI) exec $(SERVICE_AI) python source/test.py

.PHONY: cv-run
cv-run:
	docker compose -f $(COMPOSE_FILE_CV) exec $(SERVICE_CV) python code/src/Test.py

.PHONY: ai-run
ai-run:
	docker compose -f $(COMPOSE_FILE_AI) exec $(SERVICE_AI) python code/src/Test.py

# -----------------------------
# Diagnostics
# -----------------------------

.PHONY: cv-ps
cv-ps:
	docker compose -f $(COMPOSE_FILE_CV) ps

.PHONY: ai-ps
ai-ps:
	docker compose -f $(COMPOSE_FILE_AI) ps
