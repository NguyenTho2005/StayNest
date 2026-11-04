# Prompt giao việc cho AI agent — StayNest backend + PostgreSQL hosted

Sao chép nguyên khối prompt dưới đây khi giao cho một AI coding agent. Thay các giá trị trong `<...>` trước khi chạy deployment; không gửi password, certificate hoặc `DATABASE_URL` thật vào prompt/chat.

```text
Bạn là senior backend/platform engineer triển khai production hardening cho repository StayNest.

Mục tiêu
Đưa Express API của StayNest chạy với PostgreSQL 14+ hosted an toàn. Flutter chỉ gọi HTTPS Express API bằng STAYNEST_API_URL; tuyệt đối không kết nối trực tiếp tới PostgreSQL hay nhận DATABASE_URL. API nhận DATABASE_URL chỉ qua secret manager hoặc backend/.env không bị Git theo dõi. Khi database ở mạng/Internet, bắt buộc TLS có xác minh certificate.

Nguồn yêu cầu
1. Đọc kỹ docs/PRD_backend.md trước.
2. Đọc README.md, backend/package.json, backend/.env.example, backend/src/{config,db,migrate,seed,server,app}.js, backend/db/migrations/, backend/test/ và docs/BACKEND_MAPPING.md.
3. Repository đã có Express, pg, migration PostgreSQL, PGlite cho demo/test và API. Hãy audit trước, sửa tối thiểu; không rewrite theo framework/ORM khác và không phá Flutter contract hiện hữu.

Thông tin deployment đã biết (nếu giá trị chưa được quyết định, ghi BLOCKED chứ không đoán)
- API hosting/platform: <PROVIDER_OR_PENDING>
- PostgreSQL provider/region/version: <PROVIDER_REGION_VERSION_OR_PENDING>
- API public URL: <https://api.example.com_OR_PENDING>
- Flutter web origins được phép: <https://app.example.com_OR_PENDING>
- Kết nối DB: private network | allow-list static egress IP | <PENDING>
- CA database: public CA | private CA mounted as secret file | <PENDING>
- Environment thực hiện: local | staging | production

Non-negotiable
- Không đọc, yêu cầu, in, commit, hard-code hoặc thêm DATABASE_URL/password/token/certificate thật vào source, Flutter, test fixture, log, command output, issue hoặc tài liệu. Dùng placeholder.
- Không đưa DATABASE_URL vào --dart-define. Flutter chỉ có STAYNEST_API_URL public, không có slash cuối.
- Không dùng rejectUnauthorized: false, sslmode=no-verify, CORS *, public database firewall 0.0.0.0/0, superuser runtime, hoặc fallback PGlite khi production thiếu DATABASE_URL.
- Không biến demo payment/refund thành payment/refund thật; không nhận/lưu PAN/CVV; giữ nhãn demo.
- Không chỉnh sửa migration đã dùng ở môi trường chung. Thêm migration mới tăng dần; migration runner phải có tracking/locking/idempotency hoặc chứng minh rõ cơ chế đã có.
- Không tự chạy seed trong production/API startup. Seed demo phải explicit và bị chặn ở production.
- Không thay đổi API contract Flutter hay UI trừ khi bạn báo rõ breaking change, cập nhật client/test/documentation, và được phê duyệt.
- Khi thiếu quyết định hạ tầng/quyền/địa chỉ IP/domain/CA, dừng ở bước cần thiết và liệt kê BLOCKED + quyết định cần chủ dự án cung cấp. Bạn vẫn phải hoàn thành mọi audit/code/test an toàn có thể làm offline.

Cách làm bắt buộc
1. Kiểm tra trạng thái worktree và các thay đổi có sẵn; không xóa/ghi đè thay đổi không phải của bạn.
2. Audit code hiện hữu theo PRD. Bắt đầu báo cáo ngắn: [đã có], [gap], [thay đổi tối thiểu đề xuất], [rủi ro/blocker].
3. Kiểm tra config: validate URL Postgres, DATABASE_SSL/CA dependency, runtime production thiếu DATABASE_URL, CORS exact origin, pool timeout/shutdown, lỗi không rò secret. Chỉ sửa điểm có bằng chứng gap.
4. Kiểm tra migration/seed: thứ tự, ledger/lock, transaction, concurrent execution, seed idempotent và policy chặn production. Thêm test/migration mới khi cần; không tạo data catalog giả cho production.
5. Bảo toàn các invariant booking: integer VND, price/policy snapshot, Idempotency-Key, transaction/lock availability, no overbooking, ownership authorization; payment/refund vẫn demo.
6. Bổ sung runbook thực thi cho hosted PostgreSQL với placeholder: role least privilege (runtime vs migration nếu khả thi), network policy, TLS + private CA, secret injection, migration release job, readiness, rotation, backup/restore, rollback.
7. Chạy các kiểm tra khả dụng: npm ci (nếu dependency đã lock), npm run check, npm test; chạy integration PostgreSQL server nếu hạ tầng local/CI có sẵn. Không “greenwash”: ghi chính xác test nào chưa chạy và tại sao.
8. Xem diff cuối; bảo đảm .env/secrets/certificates không bị staged/tracked. Không tự deploy, tạo cloud resource, mở firewall, chạy migration production, seed production hay rotate credential nếu chưa có quyền/giá trị do chủ dự án cung cấp.

Acceptance gates
- API health/readiness hoạt động với PostgreSQL server thật qua TLS; certificate không tin cậy bị reject.
- Database chỉ accept network API; runtime role không phải superuser/owner.
- Migration chạy tuần tự, lặp lại an toàn, không race giữa nhiều API instance/release job.
- Production không được fallback sang in-memory demo.
- CORS production là exact origins; lỗi/log không lộ secret.
- Existing backend test pass; test mới cover config/migration và các invariant booking/authorization phù hợp.
- README/runbook/.env.example phản ánh đúng cách chạy; secret chỉ là placeholder.
- Báo cáo cuối có: summary, file changed, migrations, commands + results, manual steps (không secret), BLOCKED/risk, và checklist đối chiếu mục 9 của docs/PRD_backend.md.

Đầu ra cuối cùng
Không chỉ nói kế hoạch. Hãy thực hiện code/doc/test được phép trong repository và báo cáo evidence. Nếu không thể hoàn tất vì cần quyền/hạ tầng production, hoàn tất phần offline an toàn, đánh dấu BLOCKED cụ thể, và đưa command template không chứa secret để operator chạy.
```

## Mẫu giao việc theo pha

Nếu cần chia thành nhiều agent/PR, dùng thứ tự này để tránh hai agent cùng sửa cùng một phần:

1. **Audit + configuration:** `config.js`, `db.js`, shutdown, `.env.example`, `.gitignore`, config tests. Không thay migration trừ khi phát hiện blocker.
2. **Migration reliability:** migration runner/ledger/lock, seed guard/idempotency, PostgreSQL integration tests. Không thay contract API Flutter.
3. **Platform runbook + release verification:** README/runbook, deployment manifests/CI nếu repository có và đã chốt provider. Không tự tạo cloud resource/deploy.
4. **Final verification:** chạy suite, review security/diff, kiểm tra docs và acceptance criteria.

Mỗi agent phải đọc `docs/PRD_backend.md`, inspect phần đang có, và trả báo cáo evidence trước khi sửa phần giao nhau. Agent sau chỉ làm việc trên commit/diff đã được review hoặc nhận bàn giao rõ ràng.
