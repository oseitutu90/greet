# AI PR Review Setup Guide

## Overview
This automated AI PR review system triggers when:
- A PR is opened from a `feature/*` branch
- Targeting the `develop` branch
- Uses OpenAI's GPT-4o-mini model to review code changes

## Setup Instructions

### 1. Add OpenAI API Key Secret
1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add:
   - Name: `OPENAI_API_KEY`
   - Value: Your OpenAI API key from https://platform.openai.com/api-keys

### 2. Permissions
The workflow uses GitHub's default `GITHUB_TOKEN` with:
- `contents: read` - to checkout code
- `pull-requests: write` - to post comments

No additional permissions needed.

## How It Works

### Trigger Conditions
The AI review runs when:
- PR events: opened, reopened, synchronize, ready_for_review
- Base branch: `develop`
- Source branch: `feature/*`

### Review Process
1. Fetches changed files (up to 100 files, 25 analyzed)
2. Sends diff patches to OpenAI GPT-4o-mini
3. Posts:
   - Summary comment on PR timeline
   - Inline comments on specific lines with issues

### What It Reviews
- Code defects and bugs
- Security vulnerabilities
- Missing tests
- Code quality issues

## Testing

1. Create a feature branch:
   ```bash
   git checkout -b feature/test-ai-review
   ```

2. Make changes and commit:
   ```bash
   git add .
   git commit -m "Test AI review"
   git push origin feature/test-ai-review
   ```

3. Open a PR targeting `develop` branch

4. Check:
   - **Actions tab**: Verify workflow runs
   - **PR conversation**: See AI summary comment
   - **Files changed**: See inline review comments

## Customization Options

### Adjust Token Usage
Edit `.github/scripts/ai_pr_review.js`:
- `MAX_PATCH_CHARS`: Reduce from 8000 to limit diff size per file
- `.slice(0, 25)`: Reduce from 25 to analyze fewer files

### Change Target Branches
Edit `.github/workflows/ai-pr-review.yml`:
- `branches: [develop]`: Change target branch
- `if: startsWith(github.head_ref, 'feature/')`: Change source pattern

### Change AI Model
Edit `.github/scripts/ai_pr_review.js`:
- `model: "gpt-4o-mini"`: Use `gpt-4o` for more thorough reviews (higher cost)

### Skip File Types
Add filters in the script to skip:
- Documentation files (*.md)
- Lock files (package-lock.json, pom.xml.lock)
- Generated/build files

## Cost Management
- GPT-4o-mini: ~$0.002 per PR review (average)
- GPT-4o: ~$0.02 per PR review (average)
- Monitor usage at: https://platform.openai.com/usage

## Troubleshooting

### Workflow Not Running
- Verify branch names match patterns
- Check Actions tab for disabled workflows
- Ensure secrets are properly set

### No Comments Appearing
- Check Actions logs for errors
- Verify OPENAI_API_KEY is valid
- Ensure PR has actual code changes (not just docs)

### Rate Limits
- GitHub: 1000 requests/hour per repo
- OpenAI: Check your account limits

## Security Notes
- Never commit API keys directly
- The workflow runs in PR context (safe from fork attacks)
- AI suggestions should be reviewed by humans
- Consider adding CODEOWNERS for sensitive files