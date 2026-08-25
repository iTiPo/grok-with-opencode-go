#!/bin/bash
set -euo pipefail

remote_user="${_REMOTE_USER:?}"

echo "Installing Grok Build CLI for user $remote_user..."

su - "$remote_user" -c 'curl -fsSL https://x.ai/cli/install.sh | bash'

echo "Grok Build CLI installation completed."

config_file="${_REMOTE_USER_HOME:?}/.grok/config.toml"

su - "$remote_user" -c 'bash -s' <<BASH_EOF
set -euo pipefail

if ! grep -Fq '[model."opencode-deepseek-v4-pro"]' "$config_file"; then
    cat >> "$config_file" <<'TOML'

[model."opencode-deepseek-v4-pro"]
model = "deepseek-v4-pro"
base_url = "https://opencode.ai/zen/go/v1"
name = "DeepSeek V4 Pro (OpenCode Go)"
env_key = "OPENCODE_GO_API_KEY_FOR_GROK"
api_backend = "chat_completions"
max_completion_tokens = 384000
context_window = 1000000
supports_backend_search = false
reasoning_effort = "high"
stream_tool_calls = true

[model."opencode-deepseek-v4-flash"]
model = "deepseek-v4-flash"
base_url = "https://opencode.ai/zen/go/v1"
name = "DeepSeek V4 Flash (OpenCode Go)"
env_key = "OPENCODE_GO_API_KEY_FOR_GROK"
api_backend = "chat_completions"
max_completion_tokens = 384000
context_window = 1000000
supports_backend_search = false
reasoning_effort = "high"
stream_tool_calls = true

[model.opencode-kimi-k3]
model = "kimi-k3"
base_url = "https://opencode.ai/zen/go/v1"
name = "Kimi K3 (OpenCode)"
env_key = "OPENCODE_GO_API_KEY_FOR_GROK"
api_backend = "chat_completions"
max_completion_tokens = 131072
context_window = 1048576
supports_backend_search = false
reasoning_effort = "max"
stream_tool_calls = true

[model."opencode-glm-5.3"]
model = "glm-5.3"
base_url = "https://opencode.ai/zen/go/v1"
name = "GLM 5.3 (OpenCode Go)"
env_key = "OPENCODE_GO_API_KEY_FOR_GROK"
api_backend = "chat_completions"
max_completion_tokens = 131072
context_window = 1000000
supports_backend_search = false
reasoning_effort = "max"
stream_tool_calls = true

[models]
session_summary = "opencode-deepseek-v4-flash"
TOML
fi
BASH_EOF

echo "Grok Build CLI configuration updated."
