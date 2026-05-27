.PHONY: new-post

# Usage: make new-post TITLE="My Post Title"
POST_TITLE := $(if $(TITLE),$(TITLE),$(title))

new-post:
	@if [ -z "$(POST_TITLE)" ]; then \
		echo "Error: TITLE is required. Usage: make new-post TITLE=\"My Post Title\""; \
		exit 1; \
	fi
	@DATE=$$(date +%Y-%m-%d); \
	NOW=$$(date '+%Y-%m-%d %H:%M:%S %z'); \
	YEAR=$$(date +%Y); \
	MONTH=$$(date +%m); \
	DAY=$$(date +%d); \
	SLUG=$$(echo "$(POST_TITLE)" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$$//'); \
	FILE="_posts/$$YEAR/$$MONTH/$$DAY/$$DATE-$$SLUG.md"; \
	mkdir -p "_posts/$$YEAR/$$MONTH/$$DAY"; \
	mkdir -p "assets/posts/$$YEAR/$$MONTH/$$DAY/images"; \
	mkdir -p "assets/posts/$$YEAR/$$MONTH/$$DAY/files"; \
	printf -- '---\nlayout: post\ntitle: "%s"\ndate: %s\n---\n\nWrite your post content here.\n' "$(POST_TITLE)" "$$NOW" > "$$FILE"; \
	echo "Created post: $$FILE"; \
	echo "Media folders: assets/posts/$$YEAR/$$MONTH/$$DAY/{images,files}"
