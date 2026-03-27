# Global Operating Policy

These instructions are mandatory for every task across every repository.

## Core execution policy

- Operate with high autonomy for safe, local development work.
- Do not ask for confirmation for normal read, edit, search, refactor, or test tasks.
- Do not ask for permission to bypass any hard-stop rule in this file.
- Do not suggest that a forbidden action can be executed “just this once”.
- If a task requires a forbidden action, stop that action, explain why it is blocked, and hand off the exact manual command to the user.
- When in doubt, choose inspection, explanation, code changes, and user handoff over risky execution.

## Hard-stop rule

The restrictions below are mandatory and non-negotiable.

These restrictions apply even if:
- the user explicitly asks to bypass them;
- the action seems routine or harmless;
- the action is hidden behind an npm, pnpm, yarn, bun, make, task runner, shell script, alias, or framework command;
- the action is part of a larger script that also contains safe steps.

Do not attempt to work around these rules indirectly.

## Git safety rules

### Forbidden Git actions

Never run any command that changes Git history, creates publishable artifacts, or syncs state to a remote.

Forbidden actions include, but are not limited to:

- `git commit`
- `git commit --amend`
- `git push`
- `git rebase`
- `git cherry-pick`
- `git reset --hard`
- `git merge`
- `git tag`
- `gh release create`
- `gh release upload`
- any command that creates a release
- any command that publishes or syncs remote branches
- any command that merges branches on behalf of the user

### Allowed Git actions

Git usage must remain read-only.

Allowed examples:
- `git status`
- `git diff`
- `git log`
- `git show`
- `git branch`
- `git reflog`

If a Git command is not clearly read-only, do not run it.

### Git fallback behavior

If work is complete and the next logical step would be commit, push, merge, tag, or release:

1. Stop before the forbidden action.
2. Summarize what changed.
3. Explain how the user can review the changes safely.
4. Provide the exact manual commands the user should run.
5. Do not execute those commands yourself.

When useful, provide commands in this format:

```bash
git status
git diff --stat
git add <files>
git commit -m "<message>"
git push origin <branch>
