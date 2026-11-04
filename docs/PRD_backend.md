# PRD Backend — StayNest

**Phiên bản:** 1.0  
**Ngày:** 2026-11-04  
**Trạng thái:** Sẵn sàng triển khai/audit  
**Phạm vi thiết kế:** StayNest Page 1; Page 2–3 không thuộc phạm vi.

## 1. Mục tiêu

Đưa StayNest từ chế độ demo PostgreSQL trong bộ nhớ sang vận hành với PostgreSQL được lưu trữ trên Internet, theo mô hình:

```text
Flutter (web / mobile) -- HTTPS --> Express API -- TLS/private network --> PostgreSQL
```

Flutter chỉ biết URL công khai của API (`STAYNEST_API_URL`). Flutter **không** được nhận, lưu, log, build kèm hoặc kết nối bằng `DATABASE_URL`. Chỉ deployment của Express được phép đọc thông tin kết nối database từ secret manager hoặc `backend/.env` không được theo dõi bởi Git.

Mục tiêu triển khai là một backend có thể chạy local, staging và production một cách lặp lại được; migration an toàn; dữ liệu booking nhất quán; và không làm biến dữ liệu demo/thanh toán demo thành giao dịch thật.

## 2. Bối cảnh hiện tại và nguyên tắc thay đổi

Repository hiện đã có một phần backend cần được giữ lại khi phù hợp:

- Express/Node tại `backend/src`, API prefix `/api/v1`.
- `pg` dùng `DATABASE_URL`; tùy chọn `DATABASE_SSL=1` và `DATABASE_SSL_CA_FILE`; TLS hiện yêu cầu kiểm tra chứng chỉ (`rejectUnauthorized: true`).
- Migration PostgreSQL tại `backend/db/migrations/001_initial.sql`; script `npm run migrate` và `npm run seed`.
- Chế độ local/CI `STAYNEST_EMBEDDED_DEMO=1` dùng PGlite trong bộ nhớ.
- Các luồng auth, catalog, favorites, quote/booking, payment demo, hủy/refund demo và review đã có endpoint/test ở mức ban đầu.

Agent phải audit mã nguồn và test hiện có trước khi sửa. Không được thay thế kiến trúc, đổi database, đổi contract Flutter, hoặc “nâng cấp” thanh toán thật chỉ vì một thư viện/khung khác quen thuộc hơn. Mọi thay đổi phải tối thiểu, tương thích ngược hợp lý, có migration và test chứng minh.

## 3. Phạm vi MVP

### In scope

1. Kết nối Express tới PostgreSQL 14+ hosted bằng biến môi trường `DATABASE_URL`.
2. Bắt buộc TLS cho môi trường Internet; xác thực certificate; hỗ trợ CA riêng bằng file secret đã mount.
3. Thiết lập database, role ứng dụng tối thiểu quyền, network allow-list/private networking và secret management ngoài Git.
4. Quy trình migration có thứ tự, idempotent, được ghi nhận và an toàn khi chạy nhiều release.
5. Seed catalog/demo **chỉ** cho local/dev/staging được phê duyệt, không tự chạy trong production.
6. API/behavior hiện có cần tiếp tục phục vụ Flutter: auth, catalog/search, favorites, booking quote/create, trips, review; demo payment/refund chỉ giữ đúng nhãn `demo`.
7. Reliability và security tối thiểu: health/readiness, request ID, timeout DB, error không lộ secret/stack trace, CORS theo origin chính xác, validation, authorization ownership, idempotency cho tạo booking.
8. Test tự động cho config, migration, luồng booking cạnh tranh, phân quyền, và ít nhất một integration smoke test với PostgreSQL server thực nếu môi trường cho phép.
9. Tài liệu vận hành local/staging/production, rollback, backup/restore drill, và danh sách biến môi trường.

### Out of scope

- Kết nối PostgreSQL trực tiếp từ Flutter, Supabase client trực tiếp, hoặc đưa connection string vào `--dart-define`.
- PSP/thanh toán hoặc hoàn tiền thật, webhook payment thật, xử lý PAN/CVV/thông tin thẻ. Endpoint hiện tại là `demo` và phải giữ như vậy.
- Host/admin portal, OTA/channel-manager, chatbot/support vận hành thật, notification provider, OTP qua SMS/email, bản đồ/directions thật.
- Thay đổi chính sách giá, thuế, voucher, cancellation, dữ liệu catalog hoặc UX Flutter nếu chưa có quyết định sản phẩm riêng.
- Expose cổng PostgreSQL ra Internet cho tất cả IP hoặc tắt certificate verification để “chạy được”.

## 4. Yêu cầu chức năng

### 4.1 API và client boundary

- API công khai đặt sau HTTPS reverse proxy/load balancer tại một origin công khai, ví dụ `https://api.example.com`.
- Node chỉ lắng nghe mạng private/loopback theo cách deployment yêu cầu; không trực tiếp public cổng app nếu proxy đã chịu trách nhiệm TLS.
- Flutter dùng duy nhất `STAYNEST_API_URL=https://api.example.com`, không có slash cuối.
- CORS chỉ cho phép những origin web được cấu hình rõ qua `CORS_ORIGINS` (scheme + host + port); không dùng `*` trong production.
- Native Flutter không được xem CORS là lớp bảo vệ. API luôn phải xác thực và phân quyền server-side.

### 4.2 PostgreSQL

- Dùng PostgreSQL 14 trở lên, timezone/timestamp nhất quán UTC; các date lưu trú được xử lý như date, không suy diễn từ timezone của client.
- Database chỉ nhận kết nối từ API qua private network, security group, hoặc static egress IP đã allow-list. Không allow `0.0.0.0/0`.
- Tạo role runtime riêng, không dùng superuser/owner. Role này chỉ có quyền cần thiết trên schema/tables/sequences được ứng dụng truy cập; quyền chạy migration phải tách riêng nếu nền tảng cho phép.
- `DATABASE_URL` phải là URL `postgres://` hoặc `postgresql://`, do secret manager inject vào process API. Không commit `.env`; `.env.example` chỉ chứa placeholder không dùng được.
- Khi `DATABASE_SSL=1`, kết nối phải giữ `rejectUnauthorized: true`. Với CA private, mount CA như secret file rồi cấu hình đường dẫn tuyệt đối tại `DATABASE_SSL_CA_FILE`. Không dùng `rejectUnauthorized: false`.
- Pool kết nối phải giới hạn rõ, timeout kết nối/query hữu hạn và đóng sạch khi shutdown. Kích thước pool phải phù hợp connection limit provider; mặc định hiện hữu 10 chỉ thay đổi khi có cơ sở capacity cụ thể.

### 4.3 Migration và seed

- Migration là source of truth; chỉ thêm file mới tăng dần, không sửa migration đã chạy ở môi trường dùng chung. Tên file biểu đạt thứ tự và mục đích.
- Cơ chế migrate phải theo dõi migration đã áp dụng trong database, chạy tuần tự trong transaction khi PostgreSQL hỗ trợ, fail-fast, và an toàn khi chạy lại. Nếu code hiện tại chưa đáp ứng, bổ sung migration ledger/locking phù hợp.
- Migration production chạy một lần trong CI/CD release job hoặc thao tác release có kiểm soát, trước khi rollout API. Không tự chạy khi API boot nếu điều đó làm nhiều instance race nhau.
- Với thay đổi breaking, áp dụng expand → deploy tương thích → backfill → contract trong các release tách biệt; có mô tả rollback và backup trước khi thay đổi destructive.
- `npm run seed` không chạy tự động. Seed demo phải yêu cầu cờ/biến môi trường explicit và bị chặn ở production. Seed lặp lại không tạo duplicate hoặc phá dữ liệu thật.

### 4.4 Nghiệp vụ dữ liệu cần bảo toàn

- Giá tiền dùng integer VND; booking lưu snapshot giá, phí, giảm giá và cancellation policy tại thời điểm tạo.
- Tạo booking cần `Idempotency-Key`, transaction và lock/kiểm tra availability để không overbook. Lỗi tranh chấp trả mã 409 ổn định.
- Chỉ chủ thể đã xác thực mới xem/sửa dữ liệu account, favorite, booking, receipt, cancellation/refund demo và review của mình. Tài nguyên ngoài quyền phải không lộ dữ liệu.
- Token session trong database ở dạng hash; password dạng hash chuyên dụng. Log không được ghi password, token thô, `DATABASE_URL`, cookie, CA hoặc PII không cần thiết.
- Payment/refund luôn trả và lưu chỉ báo `demo`; không chấp nhận hay lưu số thẻ/CVV.

## 5. Cấu hình môi trường

| Biến | Local | Staging/Production | Quy tắc |
|---|---|---|---|
| `HOST` | `127.0.0.1` | private bind/proxy-compatible | Không dùng host public trừ khi deployment yêu cầu và firewall đã giới hạn. |
| `PORT` | `3000` | theo platform | Số nguyên 1–65535. |
| `DATABASE_URL` | URL local hoặc secret | secret manager | Bắt buộc cho server-backed DB; không vào Flutter/Git/log. |
| `DATABASE_SSL` | `0` cho local không TLS | `1` | `1` bắt buộc khi DB hosted qua mạng. |
| `DATABASE_SSL_CA_FILE` | trống/CA local | đường dẫn file secret nếu CA private | Không đưa PEM vào repo/env/log. |
| `CORS_ORIGINS` | origin dev chính xác | comma-separated exact origins | Không `*` ở production. |
| `STAYNEST_EMBEDDED_DEMO` | `1` chỉ local/CI | `0`/unset | Không cùng với `DATABASE_URL`; cấm production. |
| `SEED_DEMO_PASSWORD` | secret local riêng | unset mặc định | Không dùng password mặc định/có trong tài liệu. |
| `STAYNEST_API_URL` | Flutter build/run setting | public HTTPS API URL | Đây là biến client; không phải DB URL. |

Không thêm secret vào Docker image, Flutter asset, commit, issue, chat transcript, screenshot hoặc log CI. Nếu lộ credential: revoke/rotate ngay, audit access, thay secret deployment; không chỉ đổi trong source code.

## 6. Bảo mật và vận hành

- HTTPS bắt buộc ở edge; bật redirect/force TLS theo platform. DB TLS là lớp riêng, không thay thế API TLS.
- Bảo vệ database bằng firewall/security group + least privilege + TLS; dùng secret manager có rotation/audit log khi provider hỗ trợ.
- Có backup tự động, retention rõ ràng và point-in-time recovery nếu provider hỗ trợ. Thực hiện restore drill vào database cô lập trước khi production launch; ghi nhận kết quả và RTO/RPO thực tế.
- Health `GET /api/v1/health` biểu thị process sống; readiness `GET /api/v1/health/ready` kiểm tra query database. Load balancer chỉ route traffic khi readiness đạt.
- Shutdown nhận SIGTERM/SIGINT: ngừng nhận request mới và đóng pool trước deadline platform. Lỗi DB phải trả response có `requestId`, không stack trace/connection string.
- Theo dõi tối thiểu: uptime, readiness, HTTP 5xx, DB connection/query latency, pool exhaustion, migration outcome và backup failure. Alert không được đính kèm secret/PII.
- Trước go-live, bổ sung/đánh giá rate limit cho auth và các write endpoint công khai, header security phù hợp proxy, payload limit, dependency audit. Phạm vi thay đổi phải nêu rõ trong PR.

## 7. Môi trường và release flow

| Môi trường | Database | Seed | Mục đích |
|---|---|---|---|
| Local | PostgreSQL local hoặc PGlite embedded | cho phép explicit | phát triển/test nhanh |
| CI | PostgreSQL ephemeral/container nếu có; PGlite chỉ bổ trợ | deterministic | check/migration/test |
| Staging | PostgreSQL hosted tách riêng | chỉ catalog demo được chấp thuận | smoke test release |
| Production | PostgreSQL hosted tách riêng | không tự seed | traffic thật |

Release tối thiểu:

1. Lấy backup và kiểm tra migration plan/compatibility.
2. Inject secret vào migration job/API runtime; không hiển thị secret.
3. Chạy `npm ci`, quality checks, migration một lần, rồi kiểm tra readiness từ môi trường API.
4. Deploy API sau migration tương thích; cấu hình HTTPS và exact CORS origins.
5. Smoke test health, readiness và một luồng read-only/auth an toàn; theo dõi error/latency.
6. Nếu lỗi: dừng rollout, dùng rollback code chỉ khi schema còn tương thích; không rollback migration destructive tùy tiện. Khôi phục từ backup theo runbook khi cần.

## 8. Deliverables bắt buộc

1. Thay đổi code nhỏ nhất cần thiết, kèm test.
2. `backend/.env.example` được cập nhật an toàn; `.gitignore` xác nhận che `.env` và certificate/secret files nếu phù hợp.
3. Migration ledger/lock hoặc bằng chứng rõ ràng rằng runner hiện tại đã đảm bảo one-time ordered application; migration mới nếu schema cần thay đổi.
4. Runbook triển khai PostgreSQL hosted: tạo role/database, network policy, TLS/CA, secret injection, migrate, seed policy, deploy, health check, rotation, backup/restore, rollback.
5. Tài liệu API/contract cập nhật nếu response/request bị đổi; không đổi contract Flutter ngầm.
6. Báo cáo audit nêu: đã tồn tại gì, gap nào đã sửa, file thay đổi, command đã chạy, kết quả test, và các rủi ro/việc còn lại.

## 9. Tiêu chí nghiệm thu

### Bắt buộc

- [ ] Không có secret thật trong Git, Flutter source, `--dart-define`, test fixture, output command hoặc tài liệu.
- [ ] API khởi động và `GET /api/v1/health/ready` trả 200 với PostgreSQL hosted qua TLS có certificate hợp lệ.
- [ ] Connection TLS certificate sai/không tin cậy bị từ chối; không có bypass verification.
- [ ] DB không truy cập được từ Internet công khai; chỉ API network/egress được phép kết nối.
- [ ] Migration chạy đúng thứ tự, lần hai không thay đổi schema/data ngoài dự kiến, và không bị hai instance áp dụng song song.
- [ ] Production không thể rơi về PGlite/in-memory demo do cấu hình thiếu `DATABASE_URL`.
- [ ] CORS production chỉ cho phép origins đã khai báo; origin lạ không đọc được response qua browser.
- [ ] Suite backend hiện hữu vẫn pass; có test config/migration bổ sung và smoke/integration PostgreSQL server khi hạ tầng test có sẵn.
- [ ] Booking concurrent không vượt tồn phòng, idempotency hoạt động, và user khác không đọc được booking/favorite/profile riêng tư.
- [ ] Demo payment/refund vẫn rõ `demo`, không có PAN/CVV, không có claim giao dịch tiền thật.
- [ ] Runbook cho deploy/rotate/backup-restore/rollback đã được người triển khai có thể làm theo mà không cần đoán secret.

### Không chặn MVP nhưng phải ghi rõ nếu chưa làm

- [ ] Metrics/alert dashboard của platform cụ thể.
- [ ] Managed identity/automatic credential rotation.
- [ ] Load/performance test với connection limit production.
- [ ] DR drill chính thức với RTO/RPO được chấp thuận.

## 10. Câu hỏi phải chốt trước production

1. Chọn provider/region PostgreSQL và nơi deploy API; có private networking, static egress IP, CA private, backup/PITR gì?
2. Domain API, Flutter web origins, mobile bundle IDs, và TLS termination ở đâu?
3. Ai có quyền migration, secret rotation, database console và restore? Quy trình incident/on-call nào?
4. Dữ liệu production có được phép dùng seed catalog hiện tại không, hay phải có nguồn catalog đã duyệt?
5. RTO, RPO, retention, ngân sách connection/compute và yêu cầu pháp lý/PII là gì?
6. Khi nào payment/refund/OTP thật được phê duyệt? Đây là dự án riêng với threat model, PSP và compliance riêng.

Không tự trả lời những câu hỏi này bằng giả định kỹ thuật. Agent phải ghi `BLOCKED` và yêu cầu quyết định nếu câu trả lời làm thay đổi hạ tầng, quyền truy cập hoặc phạm vi sản phẩm.
