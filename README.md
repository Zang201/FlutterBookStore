Bookstore App
Ứng dụng Bookstore là một nền tảng bán sách trực tuyến cho phép người dùng duyệt qua các cuốn sách, thêm sách vào giỏ hàng và thực hiện giao dịch mua bán. Ứng dụng cũng hỗ trợ quản lý người dùng, phân quyền admin để thêm, sửa và xóa sách từ hệ thống.

📋 Nội dung
Giới thiệu

Tính năng

Cài đặt và sử dụng

Cấu trúc dự án

Công nghệ sử dụng

Tài liệu tham khảo

Liên hệ

📝 Giới thiệu
Bookstore App là ứng dụng quản lý bán sách trực tuyến được xây dựng bằng Flutter và Firebase. Ứng dụng cung cấp cho người dùng khả năng duyệt sách, quản lý giỏ hàng, thanh toán đơn hàng và theo dõi đơn hàng. Bên cạnh đó, ứng dụng còn có phần quản lý cho admin để thêm, sửa, và xóa sách từ cơ sở dữ liệu Firestore.

🔑 Tính năng
1. Dành cho người dùng
Đăng ký và đăng nhập bằng email, Google, Facebook.

Duyệt qua các danh mục sách.

Thêm sách vào giỏ hàng và thanh toán.

Xem lịch sử đơn hàng.

2. Dành cho admin
Đăng nhập quản trị viên.

Thêm, sửa, xóa sách trong hệ thống.

Quản lý đơn hàng và người dùng.

💻 Cài đặt và sử dụng
1. Cài đặt
Clone repository về máy tính:

bash
Sao chép
Chỉnh sửa
git clone https://github.com/your-username/FlutterBookStore.git
Di chuyển vào thư mục dự án:

bash
Sao chép
Chỉnh sửa
cd FlutterBookStore
Cài đặt các dependencies:

bash
Sao chép
Chỉnh sửa
flutter pub get
2. Chạy ứng dụng
Chạy ứng dụng trên thiết bị giả lập hoặc thiết bị thật:

bash
Sao chép
Chỉnh sửa
flutter run
🛠 Cấu trúc dự án
Dưới đây là cấu trúc thư mục của dự án:

bash
Sao chép
Chỉnh sửa
/lib
  /models         # Các mô hình dữ liệu (Book, User, Order)
  /providers      # Quản lý trạng thái bằng Provider
  /screens        # Các màn hình (Home, Cart, Admin, ...)
  /services       # Kết nối với Firebase, API
  /widgets        # Các widget tái sử dụng
  /utils          # Các công cụ hỗ trợ
  /theme          # Định nghĩa theme cho ứng dụng
⚙️ Công nghệ sử dụng
Flutter: Framework phát triển ứng dụng di động.

Firebase: Dùng cho backend, bao gồm Authentication, Firestore (cơ sở dữ liệu), và Storage.

Provider: Quản lý trạng thái trong ứng dụng.

Google Sign-In & Facebook Login: Đăng nhập bằng tài khoản Google/Facebook.

📚 Tài liệu tham khảo
Flutter Documentation

Firebase Documentation

Provider Package
