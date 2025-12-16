.PHONY: help setup install dev run test clean build up down logs shell
# Default target
.DEFAULT_GOAL := help

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m

# Environment
VENV := .venv
UV := uv

help: ## Show this help
	@echo "$(BLUE)AI Foundation Workshop$(NC)"
	@echo ""
	@echo "$(GREEN)Usage:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

# ============================================================================
# Setup & Installation
# ============================================================================

setup: ## Initial setup (create .env, install uv, create venv)
	@# 1. Create .env if missing
	@if [ ! -f .env ]; then \
		echo "$(BLUE)Creating .env file...$(NC)"; \
		cp env.example .env; \
		echo "$(GREEN)✓ .env created$(NC)"; \
		echo "$(YELLOW)⚠ Edit .env and add your GOOGLE_API_KEY$(NC)"; \
	else \
		echo "$(YELLOW).env already exists$(NC)"; \
	fi
	
	@# 2. Check for uv
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "$(BLUE)Installing uv...$(NC)"; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
	else \
		echo "$(GREEN)✓ uv is installed$(NC)"; \
	fi

	@# 3. Create venv and sync
	@echo "$(BLUE)Setting up virtual environment...$(NC)"
	@$(UV) sync
	@echo "$(GREEN)✓ Environment ready$(NC)"

install: ## Install dependencies
	@echo "$(BLUE)Syncing dependencies...$(NC)"
	@$(UV) sync
	@echo "$(GREEN)✓ Dependencies installed$(NC)"

# ============================================================================
# Development
# ============================================================================

dev: setup run ## Setup, install, and run (One command to start!)

run: ## Start JupyterLab
	@echo "$(BLUE)Starting JupyterLab...$(NC)"
	@echo "$(YELLOW)Access at: http://localhost:8888$(NC)"
	@$(UV) run jupyter lab --port=8888

# ============================================================================
# Docker
# ============================================================================

build: ## Build Docker image
	@echo "$(BLUE)Building Docker image...$(NC)"
	docker compose build
	@echo "$(GREEN)✓ Built$(NC)"

up: ## Start containers
	@echo "$(BLUE)Starting containers...$(NC)"
	docker compose up -d
	@echo "$(GREEN)✓ Running at http://localhost:8888$(NC)"

down: ## Stop containers
	@echo "$(BLUE)Stopping containers...$(NC)"
	docker compose down
	@echo "$(GREEN)✓ Stopped$(NC)"

logs: ## View container logs
	docker compose logs -f

shell: ## Open shell in container
	docker compose exec jupyter /bin/bash

restart: down up ## Restart containers

# ============================================================================
# Testing
# ============================================================================

validate: ## Validate notebook format
	@echo "$(BLUE)Validating notebooks...$(NC)"
	@for notebook in *.ipynb; do \
		$(UV) run jupyter nbconvert --to notebook --stdout "$$notebook" > /dev/null || exit 1; \
	done
	@echo "$(GREEN)✓ All valid$(NC)"

test: ## Run all notebooks to verify they execute correctly
	@echo "$(BLUE)Testing all notebooks...$(NC)"
	@for notebook in *.ipynb; do \
		echo "Running $$notebook..."; \
		$(UV) run jupyter nbconvert --to notebook --execute --stdout "$$notebook" > /dev/null || exit 1; \
	done
	@echo "$(GREEN)✓ All notebooks passed$(NC)"

# ============================================================================
# Cleanup
# ============================================================================

clean: ## Remove venv, cache, and temp files
	@echo "$(BLUE)Cleaning...$(NC)"
	rm -rf $(VENV)
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".ipynb_checkpoints" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	@$(UV) cache clean
	@echo "$(GREEN)✓ Cleaned$(NC)"

clean-all: clean down ## Clean everything including Docker
	docker compose down -v
	@echo "$(GREEN)✓ Everything cleaned$(NC)"
