# Post Organization Guide

## Overview

All blog posts are organized in date-based folders with a parallel media structure. Posts are stored in `_posts/YYYY/MM/DD/` and their media files are stored in `assets/posts/YYYY/MM/DD/`. This structure makes it easy to manage posts and their associated files while ensuring Jekyll correctly serves all media.

## Folder Structure

```
Repository Root/
├── _posts/                           # Blog post markdown files
│   └── YYYY/                         # Year (e.g., 2026)
│       └── MM/                       # Month (e.g., 01 for January)
│           └── DD/                   # Day (e.g., 28)
│               └── YYYY-MM-DD-title-of-post.md
│
└── assets/                           # Static assets served by Jekyll
    └── posts/                        # Post-specific media (mirrors _posts structure)
        └── YYYY/                     # Year
            └── MM/                   # Month
                └── DD/               # Day
                    ├── images/       # Images for this post
                    │   ├── screenshot.png
                    │   └── diagram.svg
                    └── files/        # Other files (PDFs, downloads, etc.)
                        └── document.pdf
```

## Why This Structure?

**Jekyll Compatibility**: Jekyll only processes markdown files from `_posts/` directory. Media files must be in directories that Jekyll copies to the output site (like `assets/`).

**Parallel Organization**: The date-based folder structure in both `_posts/` and `assets/posts/` keeps related content logically grouped while respecting Jekyll's build process.

## Creating a New Post

### Step 1: Create the Post Date Folder

Create a folder structure in `_posts/` matching your post date:

```bash
mkdir -p _posts/2026/01/30
```

### Step 2: Create the Post File

Create your markdown file with the standard Jekyll naming convention:

```bash
# Create the post file
touch _posts/2026/01/30/2026-01-30-my-new-post.md
```

### Step 3: Create the Media Folder (Optional)

If your post will include images or other media:

```bash
mkdir -p assets/posts/2026/01/30/images
mkdir -p assets/posts/2026/01/30/files  # For PDFs, downloads, etc.
```

### Step 4: Add Front Matter

Start your post with YAML front matter:

```markdown
---
layout: post
title: "My New Post Title"
date: 2026-01-30 10:00:00 +0000
---

Your post content starts here...
```

### Step 5: Add Media Files

Add your images, PDFs, or other files to the media folder:

```bash
# Copy your media files
cp my-diagram.png assets/posts/2026/01/30/images/
cp my-document.pdf assets/posts/2026/01/30/files/
```

### Step 6: Reference Media in Your Post

Use Jekyll's `relative_url` filter to reference media files with absolute paths:

```markdown
## Example Section

Here's an image for this post:

![Alt text]({{ '/assets/posts/2026/01/30/images/my-diagram.png' | relative_url }})

Or reference a downloadable file:

[Download PDF]({{ '/assets/posts/2026/01/30/files/my-document.pdf' | relative_url }})
```

**Important**: Always use the full path starting with `/assets/posts/YYYY/MM/DD/` and wrap it in Liquid tags with the `relative_url` filter. This ensures the URLs work correctly whether the site is deployed at the root or in a subdirectory.

## Best Practices

1. **Mirror the Structure**: Always create the same YYYY/MM/DD folder structure in both `_posts/` and `assets/posts/` for consistency.

2. **Use Subdirectories**: Create `images/` and `files/` subdirectories under `assets/posts/YYYY/MM/DD/` to keep different media types organized.

3. **Descriptive Names**: Use clear, descriptive names for media files:
   - Good: `architecture-diagram.png`
   - Bad: `img1.png`

4. **Optimize Images**: Compress images before adding them to keep repository size manageable.

5. **Use Liquid Filters**: Always use Jekyll's `relative_url` filter for media paths to ensure compatibility.

## Example Post Structure

Here's a complete example of a well-organized post:

**File Structure:**
```
_posts/2026/01/30/
└── 2026-01-30-building-microservices.md

assets/posts/2026/01/30/
├── images/
│   ├── architecture-overview.svg
│   ├── service-diagram.png
│   └── screenshot-api.png
└── files/
    └── api-documentation.pdf
```

**In the markdown file (_posts/2026/01/30/2026-01-30-building-microservices.md):**

```markdown
---
layout: post
title: "Building Microservices: A Practical Guide"
date: 2026-01-30 15:30:00 +0000
---

## Architecture Overview

Here's our microservices architecture:

![Architecture Overview]({{ '/assets/posts/2026/01/30/images/architecture-overview.svg' | relative_url }})

## Service Communication

The following diagram shows how services communicate:

![Service Diagram]({{ '/assets/posts/2026/01/30/images/service-diagram.png' | relative_url }})

## Documentation

For complete API documentation, see the [API Docs]({{ '/assets/posts/2026/01/30/files/api-documentation.pdf' | relative_url }}).
```

## Why This Structure?

1. **Logical Organization**: Posts are grouped by date, making them easy to find.
2. **Parallel Structure**: Media files mirror the post structure in `assets/`, keeping related content grouped.
3. **No Conflicts**: Media files for different posts won't conflict due to date-based folders.
4. **Easy Maintenance**: All files for a post are organized by the same date structure.
5. **Jekyll Compatible**: Jekyll properly serves files from `assets/` directory.

## Migration from Flat Structure

If you have posts in the old flat structure (`_posts/YYYY-MM-DD-title.md`), migrate them:

```bash
# For a post dated 2026-01-30
mkdir -p _posts/2026/01/30
mv _posts/2026-01-30-my-post.md _posts/2026/01/30/

# If the post has media, create the parallel structure
mkdir -p assets/posts/2026/01/30/images
# Move any existing media files to the new location
```

## Quick Reference

**Post file location:**
```
_posts/YYYY/MM/DD/YYYY-MM-DD-title.md
```

**Media file location:**
```
assets/posts/YYYY/MM/DD/images/filename.png
assets/posts/YYYY/MM/DD/files/filename.pdf
```

**Media reference in post:**
```markdown
![Image]({{ '/assets/posts/YYYY/MM/DD/images/filename.png' | relative_url }})
[Download]({{ '/assets/posts/YYYY/MM/DD/files/filename.pdf' | relative_url }})
```

## Notes

- Jekyll will find posts in any subdirectory of `_posts/`
- The post filename still needs the date prefix (YYYY-MM-DD-title.md)
- Permalinks and URLs are not affected by folder structure
- The folder structure is purely organizational
