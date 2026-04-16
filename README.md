# OBI Protocol

OBI giúp AI coding tools tự tạo và đồng bộ tài liệu dự án vào Obsidian: PRD,
BRD, spec, user stories, changelog, decision log, runbook và sync report.

## Cài Nhanh

```bash
git clone https://github.com/JstKuLam/obi-protocol ~/.obi/protocol
bash ~/.obi/protocol/scripts/install.sh
obi
```

Chạy `obi` là đủ. Wizard sẽ hỏi vài câu ngắn:

- Bạn dùng vault Obsidian hiện có hay muốn tạo vault mới?
- Bạn dùng Codex, Claude, Antigravity, hay nhiều tool cùng lúc?
- Vault/repo nằm ở đâu?

OBI sẽ luôn xác nhận lại trước khi ghi file và **không bao giờ xóa vault
Obsidian có sẵn**.

## Sau Khi Setup

Trong Codex, Claude hoặc Antigravity, gõ:

```text
/obi
```

hoặc:

```text
@obi sync docs to Obsidian
```

AI tool sẽ đọc project, tự tạo/cập nhật tài liệu cần thiết trong Obsidian và ghi
`Sync Report.md` sau mỗi lần sync.

## Lệnh Hữu Ích

```bash
obi          # mở setup wizard
obi doctor   # kiểm tra setup
obi help     # xem lệnh nâng cao
```

Update OBI:

```bash
cd ~/.obi/protocol
git pull
bash scripts/install.sh
```

## Advanced

Wizard là cách dùng chính. Các lệnh dưới đây dành cho automation hoặc setup hàng
loạt:

```bash
obi setup existing --vault-path "$HOME/Documents/Obsidian/MyBrain" --ide codex
obi setup full --vault-name MyBrain --vault-path "$HOME/Documents/Obsidian/MyBrain" --ide all
obi setup repo --repo-path "$PWD" --ide all
obi uninstall --ide all
```

## English Quick Start

```bash
git clone https://github.com/JstKuLam/obi-protocol ~/.obi/protocol
bash ~/.obi/protocol/scripts/install.sh
obi
```

Run `obi`, answer the short setup wizard, then use `/obi` or `@obi` in your AI
coding tool to sync generated project docs into Obsidian.
