# OBI Protocol

OBI là protocol để AI coding tools tự động tạo và đồng bộ tài liệu dự án vào
Obsidian: BRD, PRD, spec, user stories, changelog, decision log, runbook và các
ghi chú vận hành cần thiết.

Dùng OBI khi bạn muốn AI tool:

- Quét project hiện tại và đọc code/tài liệu có sẵn.
- Tự tạo tài liệu còn thiếu như Overview, Requirements, User Stories, Technical
  Spec, Decision Log, Changelog.
- Cập nhật Obsidian vault theo một cấu trúc ổn định.
- Giữ mỗi loại tài liệu một bản active canonical để tránh xung đột.
- Tạo `Sync Report.md` để biết lần sync vừa rồi đã tạo/sửa gì.

> `obi setup full` không bao giờ xóa vault Obsidian có sẵn.

## Setup Modes

OBI có 3 chế độ setup chính:

- `obi setup full`: phù hợp máy mới. Kiểm tra/cài Obsidian nếu có thể, tạo hoặc
  chọn vault, cài adapter IDE/CLI, và chạy smoke test.
- `obi setup existing`: phù hợp khi đã có Obsidian vault. Chỉ cấu hình OBI và cài
  adapter.
- `obi setup repo`: phù hợp repo/team. Chỉ thêm rule/adapter vào project, không
  ghi personal path vào repo.

Lệnh kiểm tra:

```bash
obi doctor
```

Lệnh gỡ cài đặt:

```bash
obi uninstall --ide all
```

## Cài Đặt OBI CLI

Từ GitHub:

```bash
git clone https://github.com/JstKuLam/obi-protocol ~/.obi/protocol
bash ~/.obi/protocol/scripts/install.sh
```

Từ checkout local:

```bash
bash ./scripts/install.sh
```

Sau khi cài, CLI/TUI mặc định nằm tại:

```text
~/bin/obi
~/bin/obi-tui
```

Nếu shell chưa nhận `obi`, thêm `~/bin` vào PATH.

## Cách Setup Khuyến Nghị: TUI

User không cần nhớ các flags bên dưới. Chạy TUI và chọn từng bước:

```bash
obi tui
```

hoặc:

```bash
obi-tui
```

TUI sẽ hỏi:

- Setup mode: full install, existing vault, repo only, doctor, uninstall.
- IDE/CLI: Codex, Claude, Antigravity, hoặc all.
- Vault path.
- Projects root hoặc Antigravity workspace path.
- Xác nhận lại command trước khi chạy.

Các lệnh manual bên dưới chỉ dành cho automation, CI, hoặc user muốn copy/paste
thẳng command.

## Cài Cho Codex

Codex dùng skill adapter tại `~/.codex/skills/obi/SKILL.md`.

Nếu đã có vault Obsidian:

```bash
obi setup existing --vault-path "$HOME/Documents/Obsidian/MyBrain" --ide codex
obi doctor
```

Nếu setup từ đầu:

```bash
obi setup full --vault-name MyBrain --vault-path "$HOME/Documents/Obsidian/MyBrain" --ide codex
obi doctor
```

Sau setup, mở session Codex mới để skill được load lại. Khi làm trong repo, gõ:

```text
/obi
```

hoặc:

```text
@obi sync docs to Obsidian
```

## Cài Cho Claude

Claude dùng slash command và context adapter:

- `~/.claude/CLAUDE.md`
- `~/.claude/commands/obi.md`
- `~/.claude/commands/obi-audit.md`
- `~/.claude/commands/obi-release.md`

Nếu đã có vault Obsidian:

```bash
obi setup existing --vault-path "$HOME/Documents/Obsidian/MyBrain" --ide claude
obi doctor
```

Nếu setup từ đầu:

```bash
obi setup full --vault-name MyBrain --vault-path "$HOME/Documents/Obsidian/MyBrain" --ide claude
obi doctor
```

Sau setup, mở Claude/Cowork session mới và gõ:

```text
/obi
```

## Cài Cho Antigravity

Antigravity dùng repo adapter vì rules thường gắn với workspace:

- `<repo>/AGENTS.md`
- `<repo>/.agent/rules/obi.md`

Trong repo cần cài:

```bash
cd /path/to/project
obi setup repo --repo-path "$PWD" --ide antigravity
```

Nếu muốn setup vault và cài adapter Antigravity cùng lúc:

```bash
obi setup existing --vault-path "$HOME/Documents/Obsidian/MyBrain" --projects-root "$PWD" --ide antigravity
obi doctor
```

Lưu ý: `setup repo` có thể tạo thay đổi trong repo, nên review `git diff` trước
khi commit.

## Cài Tất Cả IDE/CLI

Nếu máy cá nhân dùng nhiều tool:

```bash
obi setup existing --vault-path "$HOME/Documents/Obsidian/MyBrain" --projects-root "$HOME/Projects" --ide all
obi doctor
```

Mặc định `--ide all` sẽ cài Codex và Claude vào home config. Antigravity sẽ được
cài vào `--projects-root` nếu đường dẫn đó là workspace/rules root phù hợp.

## Có Cần Chia Theo Mac/Windows/Linux Không?

Không nên chia thành 3 luồng setup riêng trong README lúc này, vì sẽ làm user
mất tập trung và tăng nguy cơ stale docs. Best practice hiện tại:

- Giữ lệnh OBI giống nhau cho mọi OS.
- Chỉ ghi OS notes cho phần prerequisite.
- Để `obi setup full` xử lý khác biệt OS càng nhiều càng tốt.
- Nếu OS nào không auto-install được Obsidian, báo user cài Obsidian thủ công rồi
  chạy `obi setup existing`.

OS notes:

- macOS: auto-install Obsidian qua Homebrew nếu có `brew`.
- Linux: thử Flatpak nếu có `flatpak`.
- Windows: thử `winget` trong môi trường shell tương thích.
- Mọi OS: nếu auto-install fail, cài Obsidian thủ công và chạy `obi setup
  existing`.

## Cấu Hình Local

Config local nằm tại:

```text
~/.obi/config.toml
```

Ví dụ:

```toml
vault_path = "/Users/example/Documents/Obsidian/MyVault"
projects_root = "/Users/example/Projects"
default_project_folder = "Projects"
write_mode = "mcp-preferred"
canonical_policy = "update-active-docs"
```

Không commit file config local này vào project repo.

## Trigger Contract

Những câu sau nên kích hoạt OBI trong AI tool có adapter:

- `/obi`
- `@obi`
- `obi sync`
- `đẩy docs lên Obsidian`
- `sync tài liệu sang Obsidian`
- `tạo PRD/BRD/spec/user stories và đẩy sang Obsidian`

Xem chi tiết hành vi tại [OBI_PROTOCOL.md](./OBI_PROTOCOL.md).

## Tài Liệu Canonical

OBI ưu tiên cập nhật các file active sau:

- `Index.md`
- `Overview.md`
- `Requirements.md`
- `User Stories.md`
- `Technical Spec.md`
- `Decision Log.md`
- `Changelog.md`
- `Runbook.md`
- `Operations.md`
- `Sync Report.md`

Nếu Obsidian đã có file cũ, OBI nên cập nhật file canonical active. Chỉ tạo file
mới khi:

- Chưa có tài liệu cùng loại.
- Tài liệu cũ là archived/superseded.
- Có thay đổi lớn cần snapshot riêng.
- User yêu cầu tạo bản mới.

## English

OBI is a portable protocol for syncing AI-generated project documentation into
an Obsidian vault. It works across Codex, Claude, Antigravity, and other IDE/CLI
agents through small adapters.

### Why IDE/CLI-Specific Install Guides Exist

OBI should keep a single protocol, but each AI tool loads instructions
differently:

- Codex uses a skill in `~/.codex/skills/obi/SKILL.md`.
- Claude uses slash commands and `~/.claude/CLAUDE.md`.
- Antigravity uses project rules such as `AGENTS.md` and `.agent/rules/obi.md`.

Because of that, install instructions are split by IDE/CLI. This improves
compatibility without forking the protocol.

### Install CLI

```bash
git clone https://github.com/JstKuLam/obi-protocol ~/.obi/protocol
bash ~/.obi/protocol/scripts/install.sh
```

### Codex

```bash
obi setup existing --vault-path "$HOME/Documents/Obsidian/MyBrain" --ide codex
obi doctor
```

### Claude

```bash
obi setup existing --vault-path "$HOME/Documents/Obsidian/MyBrain" --ide claude
obi doctor
```

### Antigravity

```bash
cd /path/to/project
obi setup repo --repo-path "$PWD" --ide antigravity
```

### All Tools

```bash
obi setup existing --vault-path "$HOME/Documents/Obsidian/MyBrain" --projects-root "$HOME/Projects" --ide all
obi doctor
```

### OS Guidance

Do not split the main docs into separate Mac/Windows/Linux flows unless the setup
logic becomes meaningfully different. Keep the OBI commands consistent and use OS
notes only for prerequisites:

- macOS: Homebrew can install Obsidian during `setup full`.
- Linux: Flatpak can install Obsidian during `setup full`.
- Windows: winget can install Obsidian during `setup full`.
- Any OS: manual Obsidian install plus `obi setup existing` is the fallback.
