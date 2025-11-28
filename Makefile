.PHONY: help setup install dev run test clean build up down logs shell

# Default target
.DEFAULT_GOAL := help

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m

# Python interpreter in venv
VENV := .venv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip
JUPYTER := $(VENV)/bin/jupyter

help: ## Show this help
	@echo "$(BLUE)AI Foundation Workshop$(NC)"
	@echo ""
	@echo "$(GREEN)Usage:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

# ============================================================================
# Setup & Installation
# ============================================================================

setup: ## Initial setup (create .env and .venv)
	@# 1. Create .env if missing
	@if [ ! -f .env ]; then \
		echo "$(BLUE)Creating .env file...$(NC)"; \
		cp env.example .env; \
		echo "$(GREEN)✓ .env created$(NC)"; \
		echo "$(YELLOW)⚠ Edit .env and add your GOOGLE_API_KEY$(NC)"; \
	else \
		echo "$(YELLOW).env already exists$(NC)"; \
	fi
	
	@# 2. Create .venv if missing
	@if [ ! -d "$(VENV)" ]; then \
		echo "$(BLUE)Creating virtual environment...$(NC)"; \
		python3 -m venv $(VENV); \
		echo "$(GREEN)✓ Virtual environment created at $(VENV)$(NC)"; \
		echo "$(BLUE)Upgrading pip...$(NC)"; \
		$(PIP) install --upgrade pip; \
	else \
		echo "$(YELLOW)Virtual environment already exists$(NC)"; \
	fi

install: ## Install dependencies into .venv
	@if [ ! -d "$(VENV)" ]; then \
		echo "$(RED)Error: Virtual environment not found. Run 'make setup' first.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Installing dependencies...$(NC)"
	$(PIP) install -r requirements.txt
	@echo "$(GREEN)✓ Dependencies installed$(NC)"

# ============================================================================
# Development
# ============================================================================

dev: setup install run ## Setup, install, and run (One command to start!)

run: ## Start JupyterLab
	@if [ ! -d "$(VENV)" ]; then \
		echo "$(RED)Error: Virtual environment not found. Run 'make setup' first.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Starting JupyterLab...$(NC)"
	@echo "$(YELLOW)Access at: http://localhost:8888$(NC)"
	$(JUPYTER) lab --port=8888

# ============================================================================
# Docker
# ============================================================================

build: ## Build Docker image
	@echo "$(BLUE)Building Docker image...$(NC)"
	docker-compose build
	@echo "$(GREEN)✓ Built$(NC)"

up: ## Start containers
	@echo "$(BLUE)Starting containers...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✓ Running at http://localhost:8888$(NC)"

down: ## Stop containers
	@echo "$(BLUE)Stopping containers...$(NC)"
	docker-compose down
	@echo "$(GREEN)✓ Stopped$(NC)"

logs: ## View container logs
	docker-compose logs -f

shell: ## Open shell in container
	docker-compose exec jupyter /bin/bash

restart: down up ## Restart containers

# ============================================================================
# Testing
# ============================================================================

test: ## Run all notebooks
	@if [ ! -d "$(VENV)" ]; then \
		echo "$(RED)Error: Virtual environment not found. Run 'make setup' first.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Testing notebooks...$(NC)"
	@for notebook in *.ipynb; do \
		echo "Testing $$notebook..."; \
		$(JUPYTER) nbconvert --to notebook --execute --inplace "$$notebook" || exit 1; \
	done
	@echo "$(GREEN)✓ All tests passed$(NC)"

validate: ## Validate notebook format
	@echo "$(BLUE)Validating notebooks...$(NC)"
	@for notebook in *.ipynb; do \
		$(JUPYTER) nbconvert --to notebook --output /dev/null "$$notebook" || exit 1; \
	done
	@echo "$(GREEN)✓ All valid$(NC)"

# ============================================================================
# Cleanup
# ============================================================================

clean: ## Remove venv, cache, and temp files
	@echo "$(BLUE)Cleaning...$(NC)"
	rm -rf $(VENV)
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".ipynb_checkpoints" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	@echo "$(GREEN)✓ Cleaned$(NC)"

clean-all: clean down ## Clean everything including Docker
	docker-compose down -v
	@echo "$(GREEN)✓ Everything cleaned$(NC)"
